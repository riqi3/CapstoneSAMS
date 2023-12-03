
import os
import pickle
from django.http import JsonResponse
from rest_framework.views import APIView
from django.shortcuts import render
from django.http import HttpResponse
from rest_framework.response import Response
from .models import DiagnosticFields
import pandas as pd
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score
from hyperopt import fmin, Trials, tpe, hp, STATUS_OK #need to pip install hyperopt
from sklearn.metrics import accuracy_score

def train_model(request):
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

        # Data preprocessing
        label_columns = ['Fever', 'Cough', 'Fatigue', 'Difficulty Breathing', 'Gender', 'Blood Pressure', 'Cholesterol Level', 'Outcome Variable']
        LE = LabelEncoder()
        for col in label_columns:
            df[col] = LE.fit_transform(df[col])

        # Frequency encoding
        df['Disease_freq'] = df['Disease'].map(df['Disease'].value_counts())
        df = df.drop(columns='Disease')

        # Splitting the dataset
        X = df.drop(columns='Outcome Variable')
        y = df['Outcome Variable']
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

        # Model training with hyperparameter optimization
        def Bayesian(Space):
            RNF = RandomForestClassifier(n_estimators=int(Space['n_estimators']), criterion=Space['criterion'],
                                        max_depth=int(Space['max_depth']), max_features=Space['max_features'])
            return {'loss': -cross_val_score(RNF, X_train, y_train, cv=5).mean(), 'status': STATUS_OK}

        Space = {
            'n_estimators': hp.quniform('n_estimators', 50, 500, 50),
            'criterion': hp.choice('criterion', ['gini', 'entropy', 'log_loss']),
            'max_depth': hp.quniform('max_depth', 1, 10, 1),
            'max_features': hp.choice('max_features', ['sqrt', 'log2', None])
        }

        # Lists for mapping choices
        criterion_choices = ['gini', 'entropy', 'log_loss']
        max_features_choices = ['sqrt', 'log2', None]

        # Running hyperparameter optimization
        trials = Trials()
        Best = fmin(fn=Bayesian, space=Space, algo=tpe.suggest, max_evals=200, trials=trials)

        # Correcting the criterion and max_features parameters
        Best['criterion'] = criterion_choices[Best['criterion']]
        Best['max_features'] = max_features_choices[Best['max_features']]

        # Creating and fitting the model
        RNF = RandomForestClassifier(n_estimators=int(Best['n_estimators']), criterion=Best['criterion'],
                                    max_depth=int(Best['max_depth']), max_features=Best['max_features'])
        RNF.fit(X_train, y_train)

        # Save the model and encoder using pickle
        os.makedirs(pickle_folder, exist_ok=True)

        # Save the model
        pickle.dump(RNF, open(os.path.join(pickle_folder, 'final_rf_model.pkl'), 'wb'))

        # Save the encoder
        pickle.dump(LE, open(os.path.join(pickle_folder, 'encoder.pkl'), 'wb'))

        # Predicting and calculating accuracy
        train_predictions = RNF.predict(X_train)
        train_accuracy = accuracy_score(y_train, train_predictions)

        test_predictions = RNF.predict(X_test)
        test_accuracy = accuracy_score(y_test, test_predictions)

        # Printing the accuracy scores
        print(f"Training Data Accuracy: {train_accuracy}")
        print(f"Testing Data Accuracy: {test_accuracy}")

        return True, "Model training completed successfully."
    except Exception as e:
        return False, str(e)

class TrainModelView(APIView):
    def post(self, request):
        try:
            success, message = train_model()
            return Response({"message": message}, status=200)
        except ValueError as e:
            return Response({"message": str(e)}, status=400)
