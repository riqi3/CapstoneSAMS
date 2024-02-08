
import os
import pickle
from django.http import JsonResponse
from rest_framework.views import APIView
from django.shortcuts import render
from django.http import HttpResponse
from rest_framework.response import Response
from .models import DiagnosticFields
from rest_framework.decorators import api_view
import pandas as pd
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import GridSearchCV, train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score
from sklearn.metrics import accuracy_score
from sklearn.preprocessing import OneHotEncoder

def train_model():
    try:
        # Folder Directory
        pickle_folder = 'api/modules/disease_prediction/diagnosticModel'

        old_files = [
            'final_rf_model.pkl',
            'encoder.pkl'
        ]
        
        for file_name in old_files:
            old_file_path = os.path.join(pickle_folder, file_name)
            if os.path.exists(old_file_path):
                os.remove(old_file_path)
        
        # Load the dataset from the Django model
        diagnosis_data = DiagnosticFields.objects.all().values()
        if not diagnosis_data:
            raise ValueError("No uploaded dataset")

        df = pd.DataFrame(diagnosis_data)
        df = df[df.groupby('disease')['disease'].transform('size') >= 10]

        # Data preprocessing
        label_columns = ['fever', 'cough', 'fatigue', 'difficulty_breathing', 'gender', 'blood_pressure', 'cholesterol_level','age', 'outcome_variable', 'disease']
        LE = LabelEncoder()
        for col in label_columns:
            df[col] = LE.fit_transform(df[col])

        # Split the data
        X = df.drop(['disease'], axis=1).values
        y = df['disease'].values
        X_train, X_val, y_train, y_val = train_test_split(X, y, test_size=0.4, shuffle=True, stratify=y, random_state=30)
        X_val, X_test, y_val, y_test = train_test_split(X_val, y_val, test_size=0.5, shuffle=True, stratify=y_val, random_state=30)

        # Build and train the RandomForest model
        param_grid_rf = {
            'n_estimators': [50, 100, 200],
            'criterion': ['gini', 'entropy'],
            'max_depth': [None, 10, 20],
            'min_samples_split': [2, 5, 10],
            'min_samples_leaf': [1, 2, 4]
        }

        rf = RandomForestClassifier(class_weight='balanced', random_state=30)
        grid_search_rf = GridSearchCV(rf, param_grid_rf, cv=5)
        grid_search_rf.fit(X_train, y_train)

        # Get the best RandomForest model
        best_rf_clf = grid_search_rf.best_estimator_

        # Save the model and encoder using pickle
        os.makedirs(pickle_folder, exist_ok=True)

        # Save the model
        pickle.dump(best_rf_clf, open(os.path.join(pickle_folder, 'final_rf_model.pkl'), 'wb'))

        # Save the encoder
        pickle.dump(LE, open(os.path.join(pickle_folder, 'encoder.pkl'), 'wb'))

        # Load the encoder with explicit casting
        LE = pickle.load(open(os.path.join(pickle_folder, 'encoder.pkl'), 'rb'))

        # Check if loaded encoder is a LabelEncoder
        if not isinstance(LE, LabelEncoder):
            raise ValueError("Encoder (LE) is not of type LabelEncoder.")

        # Predicting and calculating accuracy on training data
        train_predictions = best_rf_clf.predict(X_train)
        train_accuracy = accuracy_score(y_train, train_predictions)

        # Predicting and calculating accuracy on testing data
        test_predictions = best_rf_clf.predict(X_test)
        test_accuracy = accuracy_score(y_test, test_predictions)

        # Printing the accuracy scores
        print(f"Training Data Accuracy: {train_accuracy}")
        print(f"Testing Data Accuracy: {test_accuracy}")

        return True, f"Model training completed successfully. Training Data Accuracy: {train_accuracy}, Testing Data Accuracy: {test_accuracy}"
    except Exception as e:
        return False, str(e)

class TrainModelView(APIView):
    def post(self, request):
        try:
            success, message = train_model()
            return Response({"message": message}, status=200)
        except ValueError as e:
            return Response({"message": str(e)}, status=400)
        
@api_view(['POST'])
def create_diagnostic_record(request):
    try:
        # Load the model and encoder
        pickle_folder = 'api/modules/disease_prediction/diagnosticModel'
        RNF = pickle.load(open(os.path.join(pickle_folder, 'final_rf_model.pkl'), 'rb'))
        LE = pickle.load(open(os.path.join(pickle_folder, 'encoder.pkl'), 'rb'))

        # Check if loaded encoder is a LabelEncoder
        if not isinstance(LE, LabelEncoder):
            return JsonResponse({'error_message': "Encoder (LE) is not of type LabelEncoder."}, status=500)

        if request.method == 'POST':
            # Get user input from the form
            user_input = {
                'Fever': request.data.get('fever'),
                'Cough': request.data.get('cough'),
                'Fatigue': request.data.get('fatigue'),
                'Difficulty Breathing': request.data.get('difficulty_breathing'),
                'Age': request.data.get('age'),
                'Gender': request.data.get('gender'),
                'Blood Pressure': request.data.get('blood_pressure'),
                'Cholesterol Level': request.data.get('cholesterol_level'),
                'Outcome Variable': request.data.get('outcome_variable'),
            }

            # Check for missing or empty fields
            required_fields = ['Fever', 'Cough', 'Fatigue', 'Difficulty Breathing', 'Age', 'Gender', 'Blood Pressure', 'Cholesterol Level']
            for field in required_fields:
                if not user_input[field]:
                    return JsonResponse({'error_message': f"Missing or empty value for {field}"}, status=400)

            # Convert 'Age' to integer if it's not None
            if user_input['Age'] is not None:
                try:
                    user_input['Age'] = int(user_input['Age'])
                except ValueError:
                    return JsonResponse({'error_message': "Invalid value for Age. Must be a valid integer."}, status=400)

            # Encode user input
            encoded_input = {}
            for col in user_input:
                if col == 'Age':  # Skip Age, since it's numerical
                    encoded_input[col] = user_input[col]
                else:
                    if col in ['Gender', 'Blood Pressure', 'Cholesterol Level']:  # Check if the column is categorical
                        # One-hot encode categorical variables
                        encoded_vals = pd.get_dummies([user_input[col]], prefix=col, drop_first=True)
                        for enc_col in encoded_vals.columns:
                            encoded_input[enc_col] = encoded_vals[enc_col].values[0]
                    else:
                        # For non-categorical variables, use Label Encoding
                        encoded_input[col] = LE.transform([user_input[col]])[0]

            # Create a DataFrame with the user input
            user_df = pd.DataFrame(encoded_input, index=[0])

            # Make predictions with probabilities
            prediction_proba = RNF.predict_proba(user_df)

            # Get the top 3 predicted classes and their probabilities
            top3_classes = RNF.classes_[prediction_proba.argsort()[0][-3:]][::-1]
            top3_probabilities = prediction_proba[0][prediction_proba.argsort()[0][-3:]][::-1]

            # Save the diagnostic record to the database with the disease having the highest probability
            predicted_class = top3_classes[0]
            diagnostic_record = DiagnosticFields(
                disease=predicted_class,
                fever=user_input['Fever'],
                cough=user_input['Cough'],
                fatigue=user_input['Fatigue'],
                difficulty_breathing=user_input['Difficulty Breathing'],
                age=user_input['Age'],
                gender=user_input['Gender'],
                blood_pressure=user_input['Blood Pressure'],
                cholesterol_level=user_input['Cholesterol Level'],
            )
            diagnostic_record.save()

            return JsonResponse({'top3_predictions': [{'disease': disease, 'probability': probability} for disease, probability in zip(top3_classes, top3_probabilities)]})
    except Exception as e:
        return JsonResponse({'error_message': str(e)}, status=500)

        
def get_latest_record_id(request):
    try:
        latest_record = DiagnosticFields.objects.latest('id')
        latest_record_id = latest_record.id
        return JsonResponse({'latest_record_id': latest_record_id})
    except DiagnosticFields.DoesNotExist:
        return JsonResponse({'error': 'No records found'}, status=404)
    
@api_view(['DELETE'])
def delete_symptom_record(request, record_id):
    try:
        health_symptom = DiagnosticFields.objects.get(pk=record_id)
        health_symptom.delete()
        return JsonResponse({}, status=204)
    except DiagnosticFields.DoesNotExist:
        return JsonResponse(
            {'error': 'Diagnostic record not found'},
            status=404
        )

