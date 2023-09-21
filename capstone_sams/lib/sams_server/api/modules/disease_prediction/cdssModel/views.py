from django.http import JsonResponse
from django.http import JsonResponse
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

fs = FileSystemStorage(location='tmp/')

class SymptomViewSet(viewsets.ModelViewSet):
    queryset = HealthSymptom.objects.all()
    serializer_class = HealthSymptomSerializer

    @action(detail=False, methods=['POST'])
    def upload_data(self, request):
        file = request.FILES["file"]

        content = file.read()

        file_content = ContentFile(content)
        file_name = fs.save(
            "_tmp.save", file_content
        )
        tmp_file = fs.path(file_name)

        csv_file = open(tmp_file, errors="ignore")
        reader = csv.reader(csv_file)
        next(reader)

        symptoms_list =[]
        for id_, row in enumerate(reader):
            (
                itching,
                skin_rash,
                nodal_skin_eruptions,
                continuous_sneezing,
                shivering,
                chills,
                joint_pain,
                stomach_pain,
                acidity,
                ulcers_on_tongue,
                muscle_wasting,
                vomiting,
                burning_micturition,
                spotting_urination,
                fatigue,
                weight_gain,
                anxiety,
                cold_hands_and_feets,
                mood_swings,
                weight_loss,
                restlessness,
                lethargy,
                patches_in_throat,
                irregular_sugar_level,
                cough,
                high_fever,
                sunken_eyes,
                breathlessness,
                sweating,
                dehydration,
                indigestion,
                headache,
                yellowish_skin,
                dark_urine,
                nausea,
                loss_of_appetite,
                pain_behind_the_eyes,
                back_pain,
                constipation,
                abdominal_pain,
                diarrhoea,
                mild_fever,
                yellow_urine,
                yellowing_of_eyes,
                acute_liver_failure,
                fluid_overload,
                swelling_of_stomach,
                swelled_lymph_nodes,
                malaise,
                blurred_and_distorted_vision,
                phlegm,
                throat_irritation,
                redness_of_eyes,
                sinus_pressure,
                runny_nose,
                congestion,
                chest_pain,
                weakness_in_limbs,
                fast_heart_rate,
                pain_during_bowel_movements,
                pain_in_anal_region,
                bloody_stool,
                irritation_in_anus,
                neck_pain,
                dizziness,
                cramps,
                bruising,
                obesity,
                swollen_legs,
                swollen_blood_vessels,
                puffy_face_and_eyes,
                enlarged_thyroid,
                brittle_nails,
                swollen_extremities,
                excessive_hunger,
                extra_marital_contacts,
                drying_and_tingling_lips,
                slurred_speech,
                knee_pain,
                hip_joint_pain,
                muscle_weakness,
                stiff_neck,
                swelling_joints,
                movement_stiffness,
                spinning_movements,
                loss_of_balance,
                unsteadiness,
                weakness_of_one_body_side,
                loss_of_smell,
                bladder_discomfort,
                foul_smell_of_urine,
                continuous_feel_of_urine,
                passage_of_gases,
                internal_itching,
                toxic_look_typhos,
                depression,
                irritability,
                muscle_pain,
                altered_sensorium,
                red_spots_over_body,
                belly_pain,
                abnormal_menstruation,
                dischromic_patches,
                watering_from_eyes,
                increased_appetite,
                polyuria,
                family_history,
                mucoid_sputum,
                rusty_sputum,
                lack_of_concentration,
                visual_disturbances,
                receiving_blood_transfusion,
                receiving_unsterile_injections,
                coma,
                stomach_bleeding,
                distention_of_abdomen,
                history_of_alcohol_consumption,
                fluid_overload_2,
                blood_in_sputum,
                prominent_veins_on_calf,
                palpitations,
                painful_walking,
                pus_filled_pimples,
                blackheads,
                scurrying,
                skin_peeling,
                silver_like_dusting,
                small_dents_in_nails,
                inflammatory_nails,
                blister,
                red_sore_around_nose,
                yellow_crust_ooze,
                prognosis,                
            ) = row

            symptoms_list.append(
                HealthSymptom(
                    itching=itching,
                    skin_rash=skin_rash,
                    nodal_skin_eruptions=nodal_skin_eruptions,
                    continuous_sneezing=continuous_sneezing,
                    shivering=shivering,
                    chills=chills,
                    joint_pain=joint_pain,
                    stomach_pain=stomach_pain,
                    acidity=acidity,
                    ulcers_on_tongue=ulcers_on_tongue,
                    muscle_wasting=muscle_wasting,
                    vomiting=vomiting,
                    burning_micturition=burning_micturition,
                    spotting_urination=spotting_urination,
                    fatigue=fatigue,
                    weight_gain=weight_gain,
                    anxiety=anxiety,
                    cold_hands_and_feets=cold_hands_and_feets,
                    mood_swings=mood_swings,
                    weight_loss=weight_loss,
                    restlessness=restlessness,
                    lethargy=lethargy,
                    patches_in_throat=patches_in_throat,
                    irregular_sugar_level=irregular_sugar_level,
                    cough=cough,
                    high_fever=high_fever,
                    sunken_eyes=sunken_eyes,
                    breathlessness=breathlessness,
                    sweating=sweating,
                    dehydration=dehydration,
                    indigestion=indigestion,
                    headache=headache,
                    yellowish_skin=yellowish_skin,
                    dark_urine=dark_urine,
                    nausea=nausea,
                    loss_of_appetite=loss_of_appetite,
                    pain_behind_the_eyes=pain_behind_the_eyes,
                    back_pain=back_pain,
                    constipation=constipation,
                    abdominal_pain=abdominal_pain,
                    diarrhoea=diarrhoea,
                    mild_fever=mild_fever,
                    yellow_urine=yellow_urine,
                    yellowing_of_eyes=yellowing_of_eyes,
                    acute_liver_failure=acute_liver_failure,
                    fluid_overload=fluid_overload,
                    swelling_of_stomach=swelling_of_stomach,
                    swelled_lymph_nodes=swelled_lymph_nodes,
                    malaise=malaise,
                    blurred_and_distorted_vision=blurred_and_distorted_vision,
                    phlegm=phlegm,
                    throat_irritation=throat_irritation,
                    redness_of_eyes=redness_of_eyes,
                    sinus_pressure=sinus_pressure,
                    runny_nose=runny_nose,
                    congestion=congestion,
                    chest_pain=chest_pain,
                    weakness_in_limbs=weakness_in_limbs,
                    fast_heart_rate=fast_heart_rate,
                    pain_during_bowel_movements=pain_during_bowel_movements,
                    pain_in_anal_region=pain_in_anal_region,
                    bloody_stool=bloody_stool,
                    irritation_in_anus=irritation_in_anus,
                    neck_pain=neck_pain,
                    dizziness=dizziness,
                    cramps=cramps,
                    bruising=bruising,
                    obesity=obesity,
                    swollen_legs=swollen_legs,
                    swollen_blood_vessels=swollen_blood_vessels,
                    puffy_face_and_eyes=puffy_face_and_eyes,
                    enlarged_thyroid=enlarged_thyroid,
                    brittle_nails=brittle_nails,
                    swollen_extremities=swollen_extremities,
                    excessive_hunger=excessive_hunger,
                    extra_marital_contacts=extra_marital_contacts,
                    drying_and_tingling_lips=drying_and_tingling_lips,
                    slurred_speech=slurred_speech,
                    knee_pain=knee_pain,
                    hip_joint_pain=hip_joint_pain,
                    muscle_weakness=muscle_weakness,
                    stiff_neck=stiff_neck,
                    swelling_joints=swelling_joints,
                    movement_stiffness=movement_stiffness,
                    spinning_movements=spinning_movements,
                    loss_of_balance=loss_of_balance,
                    unsteadiness=unsteadiness,
                    weakness_of_one_body_side=weakness_of_one_body_side,
                    loss_of_smell=loss_of_smell,
                    bladder_discomfort=bladder_discomfort,
                    foul_smell_of_urine=foul_smell_of_urine,
                    continuous_feel_of_urine=continuous_feel_of_urine,
                    passage_of_gases=passage_of_gases,
                    internal_itching=internal_itching,
                    toxic_look_typhos=toxic_look_typhos,
                    depression=depression,
                    irritability=irritability,
                    muscle_pain=muscle_pain,
                    altered_sensorium=altered_sensorium,
                    red_spots_over_body=red_spots_over_body,
                    belly_pain=belly_pain,
                    abnormal_menstruation=abnormal_menstruation,
                    dischromic_patches=dischromic_patches,
                    watering_from_eyes=watering_from_eyes,
                    increased_appetite=increased_appetite,
                    polyuria=polyuria,
                    family_history=family_history,
                    mucoid_sputum=mucoid_sputum,
                    rusty_sputum=rusty_sputum,
                    lack_of_concentration=lack_of_concentration,
                    visual_disturbances=visual_disturbances,
                    receiving_blood_transfusion=receiving_blood_transfusion,
                    receiving_unsterile_injections=receiving_unsterile_injections,
                    coma=coma,
                    stomach_bleeding=stomach_bleeding,
                    distention_of_abdomen=distention_of_abdomen,
                    history_of_alcohol_consumption=history_of_alcohol_consumption,
                    fluid_overload_2=fluid_overload_2,
                    blood_in_sputum=blood_in_sputum,
                    prominent_veins_on_calf=prominent_veins_on_calf,
                    palpitations=palpitations,
                    painful_walking=painful_walking,
                    pus_filled_pimples=pus_filled_pimples,
                    blackheads=blackheads,
                    scurrying=scurrying,
                    skin_peeling=skin_peeling,
                    silver_like_dusting=silver_like_dusting,
                    small_dents_in_nails=small_dents_in_nails,
                    inflammatory_nails=inflammatory_nails,
                    blister=blister,
                    red_sore_around_nose=red_sore_around_nose,
                    yellow_crust_ooze=yellow_crust_ooze,
                    prognosis=prognosis,            
                )
            )

        HealthSymptom.objects.bulk_create(symptoms_list)

        return Response("Successfully uploaded the data!")
    
# @api_view(['POST'])
# def create_symptom_record(request):
#     symptom_input = request.data.get('symptom_input', "").lower()

#     # Create a new HealthSymptom instance with values set based on user input
#     health_symptom = HealthSymptom()

#     # Set the values of the symptoms based on the user's input
#     for field in HealthSymptom._meta.fields:
#         if field.name != 'id' and field.name != 'prognosis':
#             setattr(health_symptom, field.name, 1 if field.name in symptom_input else 0)

#     # Set "prognosis" to an empty string, as it's not relevant in this case
#     health_symptom.prognosis = ""

#     # Serialize the health_symptom instance to JSON
#     serializer = HealthSymptomSerializer(health_symptom)

#     # Save the instance to the database
#     health_symptom.save()

#     return Response(serializer.data,"Successfully uploaded the data!")           
class PredictDisease(APIView):
    def post(self, request):
        symptoms = request.data["symptoms"]

        base_dir = os.path.dirname(__file__)

        svm_model_path = os.path.join(base_dir, "final_svm_model.pkl")
        final_svm_model = pickle.load(open(svm_model_path, "rb"))

        nb_model_path = os.path.join(base_dir, "final_nb_model.pkl")
        final_nb_model = pickle.load(open(nb_model_path, "rb"))

        rf_model_path = os.path.join(base_dir, "final_rf_model.pkl")
        final_rf_model = pickle.load(open(rf_model_path, "rb"))

        encoder_path = os.path.join(base_dir, "encoder.pkl")
        encoder = pickle.load(open(encoder_path, "rb"))

        symptomslist = [
            "itching",
            "skin rash",
            "nodal skin eruptions",
            "continuous sneezing",
            "shivering",
            "chills",
            "joint pain",
            "stomach pain",
            "acidity",
            "ulcers on tongue",
            "muscle wasting",
            "vomiting",
            "burning micturition",
            "spotting urination",
            "fatigue",
            "weight gain",
            "anxiety",
            "cold hands and feets",
            "mood swings",
            "weight loss",
            "restlessness",
            "lethargy",
            "patches in throat",
            "irregular sugar level",
            "cough",
            "high fever",
            "sunken eyes",
            "breathlessness",
            "sweating",
            "dehydration",
            "indigestion",
            "headache",
            "yellowish skin",
            "dark urine",
            "nausea",
            "loss of appetite",
            "pain behind the eyes",
            "back pain",
            "constipation",
            "abdominal pain",
            "diarrhoea",
            "mild fever",
            "yellow urine",
            "yellowing of eyes",
            "acute liver failure",
            "fluid overload",
            "swelling of stomach",
            "swelled lymph nodes",
            "malaise",
            "blurred and distorted vision",
            "phlegm",
            "throat irritation",
            "redness of eyes",
            "sinus pressure",
            "runny nose",
            "congestion",
            "chest pain",
            "weakness in limbs",
            "fast heart rate",
            "pain during bowel movements",
            "pain in anal region",
            "bloody stool",
            "irritation in anus",
            "neck pain",
            "dizziness",
            "cramps",
            "bruising",
            "obesity",
            "swollen legs",
            "swollen blood vessels",
            "puffy face and eyes",
            "enlarged thyroid",
            "brittle nails",
            "swollen extremeties",
            "excessive hunger",
            "extra-marital contacts",
            "drying and tingling lips",
            "slurred speech",
            "knee pain",
            "hip joint pain",
            "muscle weakness",
            "stiff neck",
            "swelling joints",
            "movement stiffness",
            "spinning movements",
            "loss of balance",
            "unsteadiness",
            "weakness of one body side",
            "loss of smell",
            "bladder discomfort",
            "foul smell of urine",
            "continuous feel of urine",
            "passage of gases",
            "internal itching",
            "toxic look (typhos)",
            "depression",
            "irritability",
            "muscle pain",
            "altered sensorium",
            "red spots over body",
            "belly pain",
            "abnormal menstruation",
            "dischromic patches",
            "watering from eyes",
            "increased appetite",
            "polyuria",
            "family history",
            "mucoid sputum",
            "rusty sputum",
            "lack of concentration",
            "visual disturbances",
            "receiving blood transfusion",
            "receiving unsterile injections",
            "coma",
            "stomach bleeding",
            "distention of abdomen",
            "history of alcohol consumption",
            "fluid overload",
            "blood in sputum",
            "prominent veins on calf",
            "palpitations",
            "painful walking",
            "pus-filled pimples",
            "blackheads",
            "scurring",
            "skin peeling",
            "silver-like dusting",
            "small dents in nails",
            "inflammatory nails",
            "blister",
            "red sore around nose",
            "yellow crust ooze",
        ]
        # Prepare the input data
        input_data = [0] * len(symptomslist)
        for symptom in symptoms:
            index = symptomslist.index(symptom)
            input_data[index] = 1
        input_data = np.array(input_data).reshape(1, -1)
        # Make the predictions
        svm_prediction = encoder.classes_[final_svm_model.predict(input_data)[0]]
        nb_prediction = encoder.classes_[final_nb_model.predict(input_data)[0]]
        rf_prediction = encoder.classes_[final_rf_model.predict(input_data)[0]]

        # Get prediction probabilities
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

        # Return the predictions
        return JsonResponse(
            {
                "predictions_with_confidence": sorted_predictions,
                "final_prediction": final_prediction,
                "final_confidence": final_confidence,
            }
        )
@api_view(['POST'])
def create_symptom_record(request):
    symptoms = request.data.get('symptoms', [])

    # Prepare the input data for the HealthSymptom model
    input_data = {}
    all_symptoms = [field.name for field in HealthSymptom._meta.fields if field.name != 'id' and field.name != 'prognosis']
    
    for symptom in all_symptoms:
        input_data[symptom] = 1 if symptom.lower() in symptoms else 0
    
    # Create a new HealthSymptom instance with values set based on user input
    health_symptom = HealthSymptom(**input_data)
    
    # Call your prediction models here and get the prognosis
    base_dir = os.path.dirname(__file__)
    svm_model_path = os.path.join(base_dir, "final_svm_model.pkl")
    final_svm_model = pickle.load(open(svm_model_path, "rb"))

    nb_model_path = os.path.join(base_dir, "final_nb_model.pkl")
    final_nb_model = pickle.load(open(nb_model_path, "rb"))

    rf_model_path = os.path.join(base_dir, "final_rf_model.pkl")
    final_rf_model = pickle.load(open(rf_model_path, "rb"))

    encoder_path = os.path.join(base_dir, "encoder.pkl")
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