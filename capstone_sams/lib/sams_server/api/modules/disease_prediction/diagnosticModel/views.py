
import json
import os
import pickle

from django.http import JsonResponse
from rest_framework.views import APIView
from django.shortcuts import render
from django.http import HttpResponse
from rest_framework.response import Response
from api.modules.disease_prediction.diagnosticModel.serializers import DiagnosticFieldsSerializer
from .models import DiagnosticFields
from rest_framework.decorators import api_view
import pandas as pd
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import GridSearchCV, train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score
from sklearn.metrics import accuracy_score
from sklearn.preprocessing import OneHotEncoder
from api.modules.user.models import Account, Data_Log

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
        label_columns = ['fever', 'cough', 'fatigue', 'difficulty_breathing', 'gender', 'blood_pressure', 'cholesterol_level','age', 'outcome_variable']
        LE = LabelEncoder()
        for col in label_columns:
            df[col] = LE.fit_transform(df[col])

        df.drop('id', axis=1, inplace=True, errors='ignore')

        # Check if there are any columns with no data (all NaN values)
        columns_with_no_data = df.columns[df.isnull().all()]

        # Drop the columns with no data
        df.drop(columns=columns_with_no_data, inplace=True)

        # Split the data
        X = df.drop(['disease'], axis=1)
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

        # Predicting and calculating accuracy on training data
        train_predictions = best_rf_clf.predict(X_train)
        train_accuracy = accuracy_score(y_train, train_predictions)

        # Predicting and calculating accuracy on testing data
        test_predictions = best_rf_clf.predict(X_test)
        test_accuracy = accuracy_score(y_test, test_predictions)

        # Printing the accuracy scores
        print(f"Training Data Accuracy: {train_accuracy}")
        print(f"Testing Data Accuracy: {test_accuracy}")

        return True, f"Model training completed successfully. Testing Data Accuracy: {test_accuracy}"
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
            required_fields = ['Fever', 'Cough', 'Fatigue', 'Difficulty Breathing', 'Age', 'Gender', 'Blood Pressure', 'Cholesterol Level', 'Outcome Variable']
            for field in required_fields:
                if field == 'Outcome Variable':
                    if user_input[field] not in ['positive', 'negative']:
                        return JsonResponse({'error_message': f"Invalid value for {field}. Must be 'positive' or 'negative'."}, status=400)
                elif not user_input[field]:
                    return JsonResponse({'error_message': f"Missing or empty value for {field}"}, status=400)

            # Convert 'Age' to integer if it's not None
            if user_input['Age'] is not None:
                try:
                    user_input['Age'] = int(user_input['Age'])
                except ValueError:
                    return JsonResponse({'error_message': "Invalid value for Age. Must be a valid integer."}, status=400)

            # Encode categorical variables using the loaded LabelEncoder
            encoded_input = {}
            for col in user_input:
                # Convert feature names to lowercase and replace spaces with underscores
                lower_col = col.lower().replace(' ', '_')
                if lower_col == 'age' or lower_col == 'gender' or lower_col == 'blood_pressure' or lower_col == 'cholesterol_level' or lower_col == 'outcome_variable':  # Skip Age, Gender, Blood Pressure, Cholesterol Level, and Outcome Variable
                    encoded_input[lower_col] = user_input[col]
                else:
                    # Convert "yes" and "no" to 1 and 0 based on training encoding
                    if user_input[col] == 'yes':
                        encoded_input[lower_col] = 1
                    elif user_input[col] == 'no':
                        encoded_input[lower_col] = 0
                    else:
                        return JsonResponse({'error_message': f"Invalid value for {col}. Must be 'yes' or 'no'."}, status=400)

            # Handle Blood Pressure separately
            valid_blood_pressure_values = ['normal', 'high', 'low']  # Define valid categories for Blood Pressure
            if user_input['Blood Pressure'].lower() not in valid_blood_pressure_values:
                return JsonResponse({'error_message': f"Invalid value for Blood Pressure. Must be one of: {', '.join(valid_blood_pressure_values)}."}, status=400)

            # Encode Blood Pressure directly to numerical value
            encoded_input['blood_pressure'] = valid_blood_pressure_values.index(user_input['Blood Pressure'].lower())

            # Handle Cholesterol Level separately
            valid_cholesterol_levels = ['normal', 'high', 'low']  # Define valid categories for Cholesterol Level
            if user_input['Cholesterol Level'].lower() not in valid_cholesterol_levels:
                return JsonResponse({'error_message': f"Invalid value for Cholesterol Level. Must be one of: {', '.join(valid_cholesterol_levels)}."}, status=400)

            # Encode Cholesterol Level directly to numerical value
            encoded_input['cholesterol_level'] = valid_cholesterol_levels.index(user_input['Cholesterol Level'].lower())

            # Handle Gender separately
            valid_genders = ['male', 'female']  # Define valid categories for Gender
            if user_input['Gender'].lower() not in valid_genders:
                return JsonResponse({'error_message': f"Invalid value for Gender. Must be one of: {', '.join(valid_genders)}."}, status=400)

            # Encode Gender directly to numerical value
            encoded_input['gender'] = valid_genders.index(user_input['Gender'].lower())

            # Handle Outcome Variable separately
            valid_outcome_values = ['positive', 'negative']  # Define valid categories for Outcome Variable
            if user_input['Outcome Variable'].lower() not in valid_outcome_values:
                return JsonResponse({'error_message': f"Invalid value for Outcome Variable. Must be one of: {', '.join(valid_outcome_values)}."}, status=400)

            # Encode Outcome Variable directly to numerical value
            encoded_input['outcome_variable'] = valid_outcome_values.index(user_input['Outcome Variable'].lower())

            # Create a DataFrame with the user input (excluding 'disease' column)
            user_df = pd.DataFrame([encoded_input])

            # Make predictions with probabilities
            prediction_proba = RNF.predict_proba(user_df)

            # Get the top 3 predicted classes and their probabilities
            top3_classes = RNF.classes_[prediction_proba.argsort()[0][-3:]][::-1]
            top3_probabilities = prediction_proba[0][prediction_proba.argsort()[0][-3:]][::-1]

            # Save the diagnostic record to the database with the disease having the highest probability
            predicted_class = top3_classes[0]
            diagnostic_record = DiagnosticFields(
                disease=predicted_class,
                fever=user_input['Fever'].title(),
                cough=user_input['Cough'].title(),
                fatigue=user_input['Fatigue'].title(),
                difficulty_breathing=user_input['Difficulty Breathing'].title(),
                age=user_input['Age'],
                gender=user_input['Gender'].title(),
                blood_pressure=user_input['Blood Pressure'].title(),
                cholesterol_level=user_input['Cholesterol Level'].title(),
                outcome_variable=user_input['Outcome Variable'].title(),
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
def delete_diagnostic_record(request, record_id):
    try:
        disease_record = DiagnosticFields.objects.get(pk=record_id)
        disease_record.delete()
        return JsonResponse({}, status=204)
    except DiagnosticFields.DoesNotExist:
        return JsonResponse(
            {'error': 'Diagnostic record not found'},
            status=404
        )

@api_view(['POST'])
def update_disease(request, record_id):
    try:
        
        disease = DiagnosticFields.objects.get(id=record_id)

        
        new_disease = request.data.get('new_disease')

        
        disease.disease = new_disease
        disease.save()

        outcome = DiagnosticFields.objects.get(id=record_id)

        outcome.outcome_variable = 'Positive'
        outcome.save()
        
        serializer = DiagnosticFieldsSerializer(outcome)
        serializer = DiagnosticFieldsSerializer(disease)
        return Response(serializer.data, status=200)

    except DiagnosticFields.DoesNotExist:
        return Response({'error': 'Diagnosticfield record not found'}, status=404)
    
@api_view(['POST'])
def update_outcome(request, record_id):
    try:
        
        outcome = DiagnosticFields.objects.get(id=record_id)

        
        outcome.outcome_variable = 'Positive'
        outcome.save()

        
        serializer = DiagnosticFieldsSerializer(outcome)
        return Response(serializer.data, status=200)

    except DiagnosticFields.DoesNotExist:
        return Response({'error': 'Diagnosticfield record not found'}, status=404)
