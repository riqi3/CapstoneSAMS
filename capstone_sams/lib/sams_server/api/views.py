import pandas as pd
import json

from django.shortcuts import render,redirect
from api.serializers import PatientSerializer, MedicineSerializer
from tabula.io import read_pdf
from django.contrib import messages
from django.http import JsonResponse

from api.models import Patient, Medicine, Health_Record, Patient_Symptoms, Medical_History, Comment, Account, Symptoms, Prescription, UploadLabResult, UploadLabResult
# from somewhere import handle_uploaded_file
from django.http import HttpResponseRedirect, HttpResponse

from rest_framework import viewsets
from rest_framework.decorators import api_view
from rest_framework.response import Response

# def process_pdf(request):
#     # file_path = "\Users\nulltest\ocr\cbc.pdf"
#     df = read_pdf(file_path, pages='all', encoding='cp1252')
#     df = df[2].to_json(orient='records')
#     return JsonResponse(df, safe=False)

# def laboratories(request):
#     if request.method == 'POST':
#          pdf = UploadFileForm()
#          pdf.name = request.POST.get('lab-result-title')
#          pdf.comments = request.POST.get('lab-results-comments')
#          if len(request.FILES) !=0:
#              pdf.file = request.FILES['lab-result-file']
#          pdf.save()
#          messages.success(request, 'File added successfully!')
#          return redirect('/')
#     return render(request, 'ocr.html')

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
        form = UploadLabResult(request.POST,request.FILES)
        if form.is_valid():
            form.save()
            return HttpResponse('The file is saved')
    else:
        form = UploadLabResult()
    return render(request, 'ocr.html', {'form':form})

def process_pdf(request):
    pdf_path = "cbc.pdf"
    dfs = read_pdf(pdf_path, pages='all', encoding='cp1252', pandas_options={'header':True})
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
            return Response({"message": "Patient created successfully."})
        except Exception as e:
            return Response({"message": "Failed to create patient.", "error": str(e)})


    @api_view(['GET'])
    def fetch_patient():
        try:
            queryset = Patient.objects.all()
            serializer = PatientSerializer(queryset, many=True)
            return Response({"message": "Patients fetched successfully.", "data": serializer.data})
        except Exception as e:
            return Response({"message": "Failed to fetch patients.", "error": str(e)})
    
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
            return Response({"message": "Patient updated successfully."})
        except Patient.DoesNotExist:
            return Response({"message": "Patient does not exist."})
        except Exception as e:
            return Response({"message": "Failed to update patient.", "error": str(e)})

class MedicineView(viewsets.ModelViewSet):

    @api_view(['GET'])
    def fetch_medicine():
        try:
            queryset = Medicine.objects.all()
            serializer = MedicineSerializer(queryset, many=True)
            return Response({"message": "Medicines fetched successfully.", "data": serializer.data})
        except Exception as e:
            return Response({"message": "Failed to fetch patients.", "error": str(e)})

class HealthRecordView(viewsets.ModelViewSet):

    @api_view(['POST'])
    def fetch_record(request, recordNum):
        recordNum = recordNum
        record = Health_Record.objects.get(pk = recordNum)
        history = Medical_History.objects.filter(health_record = record)
        patient_symptoms = Patient_Symptoms.objects.filter(medical_history = history)
        symptoms = Symptoms.objects.filter(sympNum = patient_symptoms)
        comments = Comment.objects.filter(health_record = record)
        physician = Account.objects.filter(accountID = comments.accountID)
        prescription = Prescription.objects.filter(health_record = record)
    
