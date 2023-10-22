from django.http import JsonResponse
from django.http import JsonResponse
from django.conf import settings
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
import csv
from django.core.files.base import ContentFile
from django.core.files.storage import FileSystemStorage
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import viewsets
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


fs = FileSystemStorage(location='tmp/')

class SymptomViewSet(viewsets.ModelViewSet):
    queryset = HealthSymptom.objects.all()
    serializer_class = HealthSymptomSerializer

    @action(detail=False, methods=['POST'])
    def upload_data(self, request):
        try:
            file = request.FILES["file"]
            decoded_file = file.read().decode('utf-8').splitlines()
            reader = csv.reader(decoded_file)

            symptoms_list = []

            for row in reader:
                symptoms_list.append(HealthSymptom(
                    itching=row[0],
                    skin_rash=row[1],
                    nodal_skin_eruptions=row[2],
                    continuous_sneezing=row[3],
                    shivering=row[4],
                    chills=row[5],
                    joint_pain=row[6],
                    stomach_pain=row[7],
                    acidity=row[8],
                    ulcers_on_tongue=row[9],
                    muscle_wasting=row[10],
                    vomiting=row[11],
                    burning_micturition=row[12],
                    spotting_urination=row[13],
                    fatigue=row[14],
                    weight_gain=row[15],
                    anxiety=row[16],
                    cold_hands_and_feets=row[17],
                    mood_swings=row[18],
                    weight_loss=row[19],
                    restlessness=row[20],
                    lethargy=row[21],
                    patches_in_throat=row[22],
                    irregular_sugar_level=row[23],
                    cough=row[24],
                    high_fever=row[25],
                    sunken_eyes=row[26],
                    breathlessness=row[27],
                    sweating=row[28],
                    dehydration=row[29],
                    indigestion=row[30],
                    headache=row[31],
                    yellowish_skin=row[32],
                    dark_urine=row[33],
                    nausea=row[34],
                    loss_of_appetite=row[35],
                    pain_behind_the_eyes=row[36],
                    back_pain=row[37],
                    constipation=row[38],
                    abdominal_pain=row[39],
                    diarrhoea=row[40],
                    mild_fever=row[41],
                    yellow_urine=row[42],
                    yellowing_of_eyes=row[43],
                    acute_liver_failure=row[44],
                    fluid_overload=row[45],
                    swelling_of_stomach=row[46],
                    swelled_lymph_nodes=row[47],
                    malaise=row[48],
                    blurred_and_distorted_vision=row[49],
                    phlegm=row[50],
                    throat_irritation=row[51],
                    redness_of_eyes=row[52],
                    sinus_pressure=row[53],
                    runny_nose=row[54],
                    congestion=row[55],
                    chest_pain=row[56],
                    weakness_in_limbs=row[57],
                    fast_heart_rate=row[58],
                    pain_during_bowel_movements=row[59],
                    pain_in_anal_region=row[60],
                    bloody_stool=row[61],
                    irritation_in_anus=row[62],
                    neck_pain=row[63],
                    dizziness=row[64],
                    cramps=row[65],
                    bruising=row[66],
                    obesity=row[67],
                    swollen_legs=row[68],
                    swollen_blood_vessels=row[69],
                    puffy_face_and_eyes=row[70],
                    enlarged_thyroid=row[71],
                    brittle_nails=row[72],
                    swollen_extremities=row[73],
                    excessive_hunger=row[74],
                    extra_marital_contacts=row[75],
                    drying_and_tingling_lips=row[76],
                    slurred_speech=row[77],
                    knee_pain=row[78],
                    hip_joint_pain=row[79],
                    muscle_weakness=row[80],
                    stiff_neck=row[81],
                    swelling_joints=row[82],
                    movement_stiffness=row[83],
                    spinning_movements=row[84],
                    loss_of_balance=row[85],
                    unsteadiness=row[86],
                    weakness_of_one_body_side=row[87],
                    loss_of_smell=row[88],
                    bladder_discomfort=row[89],
                    foul_smell_of_urine=row[90],
                    continuous_feel_of_urine=row[91],
                    passage_of_gases=row[92],
                    internal_itching=row[93],
                    toxic_look_typhos=row[94],
                    depression=row[95],
                    irritability=row[96],
                    muscle_pain=row[97],
                    altered_sensorium=row[98],
                    red_spots_over_body=row[99],
                    belly_pain=row[100],
                    abnormal_menstruation=row[101],
                    dischromic_patches=row[102],
                    watering_from_eyes=row[103],
                    increased_appetite=row[104],
                    polyuria=row[105],
                    family_history=row[106],
                    mucoid_sputum=row[107],
                    rusty_sputum=row[108],
                    lack_of_concentration=row[109],
                    visual_disturbances=row[110],
                    receiving_blood_transfusion=row[111],
                    receiving_unsterile_injections=row[112],
                    coma=row[113],
                    stomach_bleeding=row[114],
                    distention_of_abdomen=row[115],
                    history_of_alcohol_consumption=row[116],
                    fluid_overload_2=row[117],
                    blood_in_sputum=row[118],
                    prominent_veins_on_calf=row[119],
                    palpitations=row[120],
                    painful_walking=row[121],
                    pus_filled_pimples=row[122],
                    blackheads=row[123],
                    scurrying=row[124],
                    skin_peeling=row[125],
                    silver_like_dusting=row[126],
                    small_dents_in_nails=row[127],
                    inflammatory_nails=row[128],
                    blister=row[129],
                    red_sore_around_nose=row[130],
                    yellow_crust_ooze=row[131],
                    prognosis=row[132]
                ))

            
            HealthSymptom.objects.bulk_create(symptoms_list)

            return Response("Data uploaded successfully!")

        except Exception as e:
            return Response(f"Error during data upload: {str(e)}", status=400)


def train_disease_prediction_model():
    try:
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
        success, message = train_disease_prediction_model()
        if success:
            return Response({"message": message}, status=200)
        else:
            return Response({"message": message}, status=500)
        

@api_view(['POST'])
def create_symptom_record(request):
    
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