import pandas as pd
import json
from rest_framework import status

from django.shortcuts import render, redirect
from api.serializers import AccountSerializer, PatientSerializer, MedicineSerializer, HealthRecordSerializer, SymptomSerializer, CommentSerializer, PrescriptionSerializer, MedicineSerializer, PersonalNoteSerializer
from tabula.io import read_pdf
import csv
from django.contrib import messages
from django.http import JsonResponse

from api.models import DrugModel, UploadDrugFile, Patient, Medicine, Health_Record, Patient_Symptom, Medical_History, Comment, Account, Symptom, Prescription, Prescribed_Medicine, Personal_Note, UploadLabResult 
# from somewhere import handle_uploaded_file
from django.http import HttpResponseRedirect, HttpResponse

from rest_framework import viewsets
from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.http import JsonResponse
from rest_framework.views import APIView
import pickle
import numpy as np
from scipy.stats import mode
# def process_pdf(request):
#     # file_path = "\Users\nulltest\ocr\cbc.pdf"
#     df = read_pdf(file_path, pages='all', encoding='cp1252')
#     df = df[2].to_json(orient='records')
#     return JsonResponse(df, safe=False)

def decode_utf8(line_iterator):
    for line in line_iterator:
        yield line.decode('utf-8')

# def handle_uploaded_file(f):
#     with open('C:\Users\nulltest\ocr\upload', 'wb+') as destination:
#         for chunk in f.chunks():
#             destination.write(chunk)

# def upload_pdf(request):
#     if request.method == 'POST':
#         form = UploadFileForm(request.POST, request.FILES)
#         if form.is_valid():
#             handle_uploaded_file(request.FILES['file'])
#             return HttpResponseRedirect('/success/url/')
#     else:
#         form = UploadFileForm()
#     return render(request, 'upload.html', {'form': form})


def ViewLabResult(request):
    if request.method == 'POST':
        form = UploadLabResult(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            return HttpResponse('The file is saved')
    else:
        form = UploadLabResult()
    return render(request, 'ocr.html', {'form': form})

def ViewUploadCSV(request):
    if request.method == 'GET':
        form = UploadDrugFile()
        return render(request, 'addDrug.html', {'form': form})
    form = UploadDrugFile(request.POST, request.FILES)
    if form.is_valid():
        drugs_file = csv.reader(decode_utf8(request.FILES['sent_file']))
        next(drugs_file)

def process_pdf(request):
    pdf_path = "cbc.pdf"
    dfs = read_pdf(pdf_path, pages='all', encoding='cp1252',
                   pandas_options={'header': True})
    json_data = dfs[1].to_json(orient='columns')
    print(json_data)
    dfs[0].to_json('output.json', orient='columns')


class PatientView(viewsets.ModelViewSet):

    @api_view(['POST'])
    def create_patient(request):
        try:
            patient_data = json.loads(request.body)
            patient = Patient.objects.create(
                patientID=patient_data['patientID'],
                firstName=patient_data['firstName'],
                middleName=patient_data['middleName'],
                lastName=patient_data['lastName'],
                gender=patient_data['gender'],
                birthDate=patient_data['birthDate'],
                phone=patient_data['phone'],
                email=patient_data['email']
            )
            return Response({"message": "Patient created successfully."}, status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response({"message": "Failed to create patient.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

    @api_view(['GET'])
    def fetch_patients(request):
        try:
            queryset = Patient.objects.all()
            serializer = PatientSerializer(queryset, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch patients.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

    @api_view(['GET'])
    def fetch_patient_by_id(request, patientID):
        try:
            queryset = Patient.objects.filter(pk=patientID)
            serializer = PatientSerializer(queryset.first())
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch patients.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

    @api_view(['PUT'])
    def update_patient(request):
        try:
            patient_data = json.loads(request.body)
            patient_id = patient_data['patientID']
            patient = Patient.objects.get(pk=patient_id)
            patient.firstName = patient_data['firstName']
            patient.middleName = patient_data['middleName']
            patient.lastName = patient_data['lastName']
            patient.gender = patient_data['gender']
            patient.birthDate = patient_data['birthDate']
            patient.phone = patient_data['phone']
            patient.email = patient_data['email']
            patient.save()
            return Response({"message": "Patient updated successfully."}, status=status.HTTP_200_OK)
        except Patient.DoesNotExist:
            return Response({"message": "Patient does not exist."}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"message": "Failed to update patient.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)


class MedicineView(viewsets.ModelViewSet):

    @api_view(['GET'])
    def fetch_medicine(request):
        try:
            queryset = Medicine.objects.all()
            serializer = MedicineSerializer(queryset, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch medicines.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
        
    @api_view(['GET'])
    def fetch_medicine_by_id(request, drugID):
        try:
            queryset = Medicine.objects.filter(pk=drugID)
            serializer = MedicineSerializer(queryset, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch medicine.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
    
    @api_view(['GET'])
    def fetch_medicine_through_prescription(request, presNum):
        try:
            prescription = Prescription.objects.get(pk=presNum)
            prescribed_medicines = Prescribed_Medicine.objects.filter(prescription=prescription)
            medicines = [prescribed_medicine.medicine for prescribed_medicine in prescribed_medicines]
            serializer = MedicineSerializer(medicines, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
             return Response({"message": "Failed to fetch medicine.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
            

class CommentView(viewsets.ModelViewSet):

    @api_view(['POST'])
    def create_comment(request, accountId, recordNum):
        try:
            comment_data = json.loads(request.body)
            account = Account.objects.get(pk=accountId)
            record = Health_Record.objects.get(pk=recordNum)
            comment = Comment.objects.create(
                content = comment_data['content'],
                account = account,
                health_record = record
            )
            return Response({"message": "Comment successfully created"}, status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response({"message": "Failed to create comment"}, status=status.HTTP_400_BAD_REQUEST)
    
    @api_view(['GET'])
    def fetch_comments(request):
        try:
            queryset = Comment.objects.all()
            serializer = CommentSerializer(queryset, many = True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch comments.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
    
    @api_view(['GET'])
    def fetch_comments_by_account_id(request, accountId):
        try:
            account = Account.objects.get(pk=accountId)
            queryset = Comment.objects.filter(account=account)

            account_serializer = AccountSerializer(account)
            serializer = CommentSerializer(queryset, many = True)
            response_data = {
                'comments' : serializer.data,
                'account': account_serializer.data
            }
            return Response(response_data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch comments.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
        
    @api_view(['PUT'])
    def update_comment(request, comNum):
        try:
            comments_data = json.loads(request.body)
            comment = Comment.objects.get(pk = comNum)
            comment.content = comments_data['content']
            comment.save()
            return Response({"message": "Comment successfully update"}, status=status.HTTP_204_NO_CONTENT)
        except Exception as e:
            return Response({"message": "Failed to update comment", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
    
    @api_view(['DELETE'])
    def delete_comment(request, comNum):
        try:
            comment = Comment.objects.get(pk = comNum)
            comment.delete()
            return Response({"message": "Comment successfully deleted"}, status=status.HTTP_204_NO_CONTENT)
        except Exception as e:
             return Response({"message": "Failed to delete comment", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)



# class HealthRecordView(viewsets.ViewSet):

#     @api_view(['GET'])
#     def fetch_records(request):
#         try:
#             records = Health_Record.objects.all()
#             response_data = []
#             for record in records:
#                 #Patient History and Symptoms
#                 history = Medical_History.objects.filter(record=record)
#                 patient_symptoms = Patient_Symptom.objects.filter(medical_history=history)
#                 symptoms = [symptom.symptom for symptom in patient_symptoms]
#                 print(symptoms)

#                 #Patient Personal Info
#                 patient = records.patient
#                 print(patient)

#                 #Accounts and Comment
#                 comments = Comment.objects.filter(record=record)
#                 physician = [comment.account for comment in comments]
#                 print(physician)

#                 #Medicines and Prescription
#                 prescription = Prescription.objects.filter(health_record=record)
#                 prescribed_medicines = Prescribed_Medicine.objects.filter(prescription=prescription)
#                 medicines = [medicine.medicine for medicine in prescribed_medicines]
#                 print(medicines)
                
#                 # Serialize the data
#                 history_data = HealthRecordSerializer(record).data
#                 patient_data = PatientSerializer(patient).data
#                 symptoms_data = SymptomSerializer(symptoms, many=True).data
#                 comments_data = CommentSerializer(comments, many=True).data
#                 physician_data = AccountSerializer(physician, many=True).data
#                 prescription_data = PrescriptionSerializer(prescription, many=True).data
#                 medicines_data = MedicineSerializer(medicines, many=True).data

#                 record_data = {
#                     'history': history_data,
#                     'physicians': physician_data,
#                     'patients': patient_data,
#                     'symptoms': symptoms_data,
#                     'comments': comments_data,
#                     'prescription': prescription_data,
#                     'medicines': medicines_data,
#                 }

#                 response_data.append(record_data)
            
#             print(response_data)
#             return Response(response_data, status=status.HTTP_200_OK)
#         except Exception as e:
#             return Response({"message": "Failed to fetch health records", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)


#     @api_view(['GET'])
#     def fetch_record_by_num(request):
#         try:
#             data = json.loads(request.body)
#             recordNum = data['recordNum']
#             record = Health_Record.objects.get(pk=recordNum)
#             history = Medical_History.objects.filter(health_record=record)
#             patient_symptoms = Patient_Symptom.objects.filter(
#                 medical_history__in=history)
#             symptoms = Symptom.objects.filter(
#                 patient_symptoms__in=patient_symptoms)
#             comments = Comment.objects.filter(health_record=record)
#             physician = Account.objects.filter(comment__in=comments)
#             prescription = Prescription.objects.filter(health_record=record)
#             prescribed_medicines = Prescribed_Medicine.objects.filter(
#                 prescription__in=prescription)
#             medicines = Medicine.objects.filter(
#                 prescribed_medicine__in=prescribed_medicines)

#             history_data = HealthRecordSerializer(record)
#             physician_data = AccountSerializer(physician, many=True)
#             symptoms_data = SymptomSerializer(symptoms, many=True)
#             comments_data = CommentSerializer(comments, many=True)
#             prescription_data = PrescriptionSerializer(prescription, many=True)
#             medicines_data = MedicineSerializer(medicines, many=True)

#             response_data = {
#                 'history': history_data.data,
#                 'physicians': physician_data.data,
#                 'symptoms': symptoms_data.data,
#                 'comments': comments_data.data,
#                 'presription': prescription_data.data,
#                 'medicines': medicines_data.data,
#             }

#             return Response(response_data, status=status.HTTP_200_OK)

#         except Exception as e:
#             return Response({"message": "Failed to fetch health record", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

class SymptomsView(viewsets.ModelViewSet):
    
    @api_view(['GET'])
    def fetch_symptoms(request):
        try:
            symptoms = Symptom.objects.all()
            serializer = SymptomSerializer(symptoms, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch symptoms", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
    
    @api_view(['GET'])
    def fetch_symptoms_by_num(request, sympNum):
        try:
            symptoms = Symptom.objects.get(pk=sympNum)
            serializer = SymptomSerializer(symptoms)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch symptoms", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

class PersonalNotesView(viewsets.ModelViewSet):
    
    @api_view(['GET'])
    def fetch_personal_notes(request, accountID):
        try:
            personal_notes = Personal_Note.objects.filter(account__pk=accountID)
            serializer = PersonalNoteSerializer(personal_notes, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch personal notes"}, status=status.HTTP_400_BAD_REQUEST)

    @api_view(['POST']) 
    def create_personal_note(request):
        try:
            notes_data = json.loads(request.body)
            account_id = notes_data['account']
            account = Account.objects.get(accountID = account_id)
            note = Personal_Note.objects.create(
                title = notes_data['title'],
                content = notes_data['content'],
                account = account
            )
            return Response({"message": "Note successfully created"}, status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response({"message": "Failed to create note"}, status=status.HTTP_400_BAD_REQUEST)

    @api_view(['PUT'])
    def update_personal_note(request, noteNum):
        try:
            notes_data = json.loads(request.body)
            note = Personal_Note.objects.get(pk=noteNum)
            note.title = notes_data['title']
            note.content = notes_data['content']
            note.save()
            return Response({"message": "Note successfully update"}, status=status.HTTP_204_NO_CONTENT)
        except Exception as e:
            return Response({"message": "Failed to update note", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

    @api_view(['DELETE'])
    def delete_personal_note(request, noteNum):
        try:
            note = Personal_Note.objects.get(pk=noteNum)
            note.delete()
            return Response({"message": "Note successfully deleted"}, status=status.HTTP_204_NO_CONTENT)
        except Exception as e:
             return Response({"message": "Failed to delete note", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
        
class PrescriptionView(viewsets.ViewSet):
    @api_view(['GET'])
    def fetch_prescription_by_ids(request, accountId, recordNum):
        try:
            account = Account.objects.get(pk=accountId)
            record = Health_Record.objects.get(pk=recordNum)
            prescription = Prescription.objects.get(account = account, health_record = record)
            serializer = PrescriptionSerializer(prescription)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
             return Response({"message": "Failed to fetch prescription", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

#def predict(request):
    # Get symptoms from GET parameters
#     symptoms = request.GET.getlist('symptoms')

class PredictDisease(APIView):
    def get(self, request):
        symptoms = request.GET.get('symptoms').split(",")

        # Load the models from disk
        final_svm_model = pickle.load(open('final_svm_model.pkl', 'rb'))
        final_nb_model = pickle.load(open('final_nb_model.pkl', 'rb'))
        final_rf_model = pickle.load(open('final_rf_model.pkl', 'rb'))
        encoder = pickle.load(open('encoder.pkl', 'rb'))
        symptomslist=["itching","skin rash","nodal skin eruptions","continuous sneezing","shivering","chills","joint pain","stomach pain","acidity","ulcers on tongue","muscle wasting","vomiting","burning micturition","spotting urination","fatigue","weight gain","anxiety","cold hands and feets","mood swings","weight loss","restlessness","lethargy","patches in throat","irregular sugar level","cough",
        "high fever","sunken eyes","breathlessness","sweating","dehydration","indigestion","headache","yellowish skin","dark urine","nausea","loss of appetite","pain behind the eyes","back pain","constipation","abdominal pain","diarrhoea","mild fever","yellow urine","yellowing of eyes","acute liver failure","fluid overload","swelling of stomach","swelled lymph nodes","malaise","blurred and distorted vision",

        "phlegm","throat irritation","redness of eyes","sinus pressure","runny nose","congestion","chest pain","weakness in limbs","fast heart rate","pain during bowel movements","pain in anal region","bloody stool","irritation in anus","neck pain","dizziness","cramps","bruising","obesity","swollen legs","swollen blood vessels","puffy face and eyes","enlarged thyroid","brittle nails","swollen extremeties",
        "excessive hunger","extra-marital contacts","drying and tingling lips","slurred speech","knee pain","hip joint pain","muscle weakness","stiff neck","swelling joints","movement stiffness","spinning movements","loss of balance","unsteadiness","weakness of one body side","loss of smell","bladder discomfort","foul smell of urine","continuous feel of urine","passage of gases","internal itching",
        "toxic look (typhos)","depression","irritability","muscle pain","altered sensorium","red spots over body","belly pain","abnormal menstruation","dischromic patches","watering from eyes","increased appetite","polyuria","family history","mucoid sputum","rusty sputum","lack of concentration","visual disturbances","receiving blood transfusion","receiving unsterile injections","coma","stomach bleeding",
        "distention of abdomen","history of alcohol consumption","fluid overload","blood in sputum","prominent veins on calf","palpitations","painful walking","pus-filled pimples","blackheads","scurring","skin peeling","silver-like dusting","small dents in nails","inflammatory nails","blister","red sore around nose","yellow crust ooze"]
        # Prepare the input data
        input_data = [0] * len(symptomslist)
        for symptom in symptoms:
            index = symptomslist.index(symptom)
            input_data[index] = 1
        input_data = np.array(input_data).reshape(1,-1)
        # Make the predictions
        svm_prediction = encoder.classes_[final_svm_model.predict(input_data)[0]]
        nb_prediction = encoder.classes_[final_nb_model.predict(input_data)[0]]
        rf_prediction = encoder.classes_[final_rf_model.predict(input_data)[0]]
        final_prediction = mode([svm_prediction, nb_prediction, rf_prediction])[0][0]
        # Return the predictions
        return JsonResponse({
            "svm_prediction": svm_prediction,
            "nb_prediction": nb_prediction,
            "rf_prediction": rf_prediction,
            "final_prediction": final_prediction
        })