from django.http import JsonResponse
from django.http import JsonResponse
from django.conf import settings
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
import csv, json
from django.core.files.base import ContentFile
from django.core.files.storage import FileSystemStorage
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import viewsets

from api.modules.user.models import Account, Data_Log
from .models import HealthSymptom
from .serializers import HealthSymptomSerializer
from rest_framework.views import APIView
import pickle
import numpy as np
from statistics import mode
import os
from collections import Counter
import pandas as pd
import numpy as np
import pickle
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.svm import SVC
from sklearn.naive_bayes import GaussianNB
from sklearn.ensemble import RandomForestClassifier
from scipy.stats import mode
import warnings


def train_disease_prediction_model():
    try:
        account_id = data["accountID"] 
        account = Account.objects.get(pk=account_id)
        data_log = Data_Log.objects.create(
            event=f"{account.username} has trained the model",
            type="Model Training",
            account=account,
            )
        # Folder Directory
        pickle_folder = 'api/modules/disease_prediction/cdssModel'
        
        # If no folder only
        if not os.path.exists(pickle_folder):
            os.makedirs(pickle_folder)

        
        old_files = [
            'final_svm_model.pkl',
            'final_nb_model.pkl',
            'final_rf_model.pkl',
            'encoder.pkl'
        ]
        
        for file_name in old_files:
            old_file_path = os.path.join(pickle_folder, file_name)
            if os.path.exists(old_file_path):
                os.remove(old_file_path)


        # Load the dataset
        symptoms_data = HealthSymptom.objects.all().values()
        if not symptoms_data:
            raise ValueError("No uploaded dataset")

        data = pd.DataFrame(symptoms_data)

        # Encode the target value into numerical value using LabelEncoder
        encoder = LabelEncoder()
        data["prognosis"] = encoder.fit_transform(data["prognosis"])

        # Check if there are any columns with no data (all NaN values)
        columns_with_no_data = data.columns[data.isnull().all()]

        # Drop the columns with no data
        data.drop(columns=columns_with_no_data, inplace=True)

        # Split the data into training and testing sets
        X = data.drop("prognosis", axis=1)
        y = data["prognosis"]
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

        # Train the models
        final_svm_model = SVC(probability=True)
        final_nb_model = GaussianNB()
        final_rf_model = RandomForestClassifier(random_state=18)

        final_svm_model.fit(X_train, y_train)
        final_nb_model.fit(X_train, y_train)
        final_rf_model.fit(X_train, y_train)

        # Evaluate the models on training data
        svm_train_accuracy = final_svm_model.score(X_train, y_train)
        nb_train_accuracy = final_nb_model.score(X_train, y_train)
        rf_train_accuracy = final_rf_model.score(X_train, y_train)

        # Evaluate the models on testing data
        svm_test_accuracy = final_svm_model.score(X_test, y_test)
        nb_test_accuracy = final_nb_model.score(X_test, y_test)
        rf_test_accuracy = final_rf_model.score(X_test, y_test)

        # Print the accuracies
        print("SVM Training Accuracy: ", svm_train_accuracy)
        print("Naive Bayes Training Accuracy: ", nb_train_accuracy)
        print("Random Forest Training Accuracy: ", rf_train_accuracy)

        print("SVM Testing Accuracy: ", svm_test_accuracy)
        print("Naive Bayes Testing Accuracy: ", nb_test_accuracy)
        print("Random Forest Testing Accuracy: ", rf_test_accuracy)
        # Save the models to the specified folder
        pickle.dump(final_svm_model, open(os.path.join(pickle_folder, 'final_svm_model.pkl'), 'wb'))
        pickle.dump(final_nb_model, open(os.path.join(pickle_folder, 'final_nb_model.pkl'), 'wb'))
        pickle.dump(final_rf_model, open(os.path.join(pickle_folder, 'final_rf_model.pkl'), 'wb'))
        pickle.dump(encoder, open(os.path.join(pickle_folder, 'encoder.pkl'), 'wb'))

        return True, "Model training completed successfully."
    except Exception as e:
        return False, str(e)

class TrainModelView(APIView):
    def post(self, request):
        try:
            success, message = train_disease_prediction_model()
            return Response({"message": message}, status=200)
        except ValueError as e:
            return Response({"message": str(e)}, status=400)
        

@api_view(['POST'])
def create_symptom_record(request):
    data = json.loads(request.body)
    account_id = data["accountID"] 
    account = Account.objects.get(pk=account_id)
    data_log = Data_Log.objects.create(
        event=f"{account.username} has inputted a symptom record",
        type="Create Symptom record",
        account=account,
        )
    warnings.filterwarnings("ignore", category=UserWarning, module="sklearn")

    symptoms = request.data.get('symptoms', [])
    symptoms = [symptom.replace(' ', '_') for symptom in symptoms]

    
    input_data = {}
    all_symptoms = [field.name.replace(' ', '_') for field in HealthSymptom._meta.fields if field.name != 'id']

    for symptom in all_symptoms:
        input_data[symptom] = 1 if symptom.lower() in [user_symptom.lower() for user_symptom in symptoms] else 0
    

    
    health_symptom = HealthSymptom(**input_data)
    
    
    project_directory = settings.BASE_DIR

    # Folder directory
    model_folder = os.path.join(project_directory, 'api/modules/disease_prediction/cdssModel')
    
    svm_model_path = os.path.join(model_folder, "final_svm_model.pkl")
    final_svm_model = pickle.load(open(svm_model_path, "rb"))

    nb_model_path = os.path.join(model_folder, "final_nb_model.pkl")
    final_nb_model = pickle.load(open(nb_model_path, "rb"))

    rf_model_path = os.path.join(model_folder, "final_rf_model.pkl")
    final_rf_model = pickle.load(open(rf_model_path, "rb"))

    encoder_path = os.path.join(model_folder, "encoder.pkl")
    encoder = pickle.load(open(encoder_path, "rb"))

    input_data = [0] * len(all_symptoms)
    for symptom in symptoms:
        if symptom.lower() in all_symptoms:
            index = all_symptoms.index(symptom.lower())
            input_data[index] = 1
    input_data = np.array(input_data).reshape(1, -1)

    svm_prediction = encoder.classes_[final_svm_model.predict(input_data)[0]]
    nb_prediction = encoder.classes_[final_nb_model.predict(input_data)[0]]
    rf_prediction = encoder.classes_[final_rf_model.predict(input_data)[0]]

    svm_prob = max(final_svm_model.predict_proba(input_data)[0])
    nb_prob = max(final_nb_model.predict_proba(input_data)[0])
    rf_prob = max(final_rf_model.predict_proba(input_data)[0])

    # Combine predictions and probabilities
    predictions_with_confidence = {
        "SVM": {"prediction": svm_prediction, "confidence": svm_prob},
        "Naive Bayes": {"prediction": nb_prediction, "confidence": nb_prob},
        "Random Forest": {"prediction": rf_prediction, "confidence": rf_prob},
    }
    # Sort predictions by confidence
    sorted_predictions = sorted(
        predictions_with_confidence.items(),
        key=lambda item: item[1]["confidence"],
        reverse=True,
    )

    # The final prediction is based on the model with the highest confidence score
    final_prediction = sorted_predictions[0][1]["prediction"]
    final_confidence = sorted_predictions[0][1]["confidence"]

    # Serialize the health_symptom instance to JSON
    serializer = HealthSymptomSerializer(health_symptom)

    # Set the prognosis obtained from the prediction models
    health_symptom.prognosis = final_prediction

    # Save the instance to the database
    health_symptom.save()

    # Return the response with both symptom recording and prediction
    response_data = {
        "symptom_record": serializer.data,
        "predictions_with_confidence": sorted_predictions,
        "final_prediction": final_prediction,
        "final_confidence": final_confidence,
    }
    
    return Response(response_data, status=200)

def get_latest_record_id(request):
    try:
        latest_record = HealthSymptom.objects.latest('id')
        latest_record_id = latest_record.id
        return JsonResponse({'latest_record_id': latest_record_id})
    except HealthSymptom.DoesNotExist:
        return JsonResponse({'error': 'No records found'}, status=404)

@api_view(['DELETE'])
def delete_symptom_record(request, record_id):
    try:
        health_symptom = HealthSymptom.objects.get(pk=record_id)
        health_symptom.delete()
        return JsonResponse({}, status=204)
    except HealthSymptom.DoesNotExist:
        return JsonResponse(
            {'error': 'Symptom record not found'},
            status=404
        )
    
@api_view(['POST'])
def update_prognosis(request, record_id):
    try:
        
        health_symptom = HealthSymptom.objects.get(id=record_id)

        
        new_prognosis = request.data.get('new_prognosis')

        
        health_symptom.prognosis = new_prognosis
        health_symptom.save()

        
        serializer = HealthSymptomSerializer(health_symptom)
        return Response(serializer.data, status=200)

    except HealthSymptom.DoesNotExist:
        return Response({'error': 'HealthSymptom record not found'}, status=404)