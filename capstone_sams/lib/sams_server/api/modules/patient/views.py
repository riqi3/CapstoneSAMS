
from django.shortcuts import get_object_or_404
from rest_framework import viewsets
from rest_framework.decorators import api_view
from rest_framework.response import Response
import json
from rest_framework import status

from api.modules.user.models import Account, Data_Log
from api.modules.patient.models import Patient, Health_Record
from api.modules.patient.serializers import PatientSerializer, HealthRecordSerializer

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
                age=patient_data['age'],
                gender=patient_data['gender'],
                birthDate=patient_data['birthDate'],
                registration=patient_data['registration'],
                phone=patient_data['phone'],
                email=patient_data['email']
            )
            patient_instance = get_object_or_404(Patient, pk=patient_data['patientID'])
            record = Health_Record.objects.create(
                symptoms = {"symptoms": "None"},
                diseases = {"diseases": "None"},
                patient = patient_instance
            )
            data = json.loads(request.body)
            accountID = data['account']
            account = get_object_or_404(Account, pk=accountID)
            data_log = Data_Log.objects.create(
                event = f"{account.username} created patient",
                type = "User Created Patient",
                account = account
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
            patient.age = patient_data['age']
            patient.gender = patient_data['gender']
            patient.birthDate = patient_data['birthDate']
            patient.phone = patient_data['phone']
            patient.email = patient_data['email']
            patient.save()
            accountID = patient_data['account']
            account = get_object_or_404(Account, pk=accountID)
            data_log = Data_Log.objects.create(
                event = f"{account.username} updated patient id {patient_id}",
                type = "User Update Patient Data",
                account = account
            )
            return Response({"message": "Patient updated successfully."}, status=status.HTTP_200_OK)
        except Patient.DoesNotExist:
            return Response({"message": "Patient does not exist."}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"message": "Failed to update patient.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)


class HealthRecordView(viewsets.ViewSet):

    @api_view(['GET'])
    def fetch_record_by_id(request, patientID):
        try:
            record = Health_Record.objects.filter(pk=patientID)
            serializer = HealthRecordSerializer(record)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Health_Record.DoesNotExist:
            return Response({"message": "Health Record does not exist."}, status=status.HTTP_404_NOT_FOUND)


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


# class SymptomsView(viewsets.ModelViewSet):
    
#     @api_view(['GET'])
#     def fetch_symptoms(request):
#         try:
#             symptoms = Symptom.objects.all()
#             serializer = SymptomSerializer(symptoms, many=True)
#             return Response(serializer.data, status=status.HTTP_200_OK)
#         except Exception as e:
#             return Response({"message": "Failed to fetch symptoms", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
    
#     @api_view(['GET'])
#     def fetch_symptoms_by_num(request, sympNum):
#         try:
#             symptoms = Symptom.objects.get(pk=sympNum)
#             serializer = SymptomSerializer(symptoms)
#             return Response(serializer.data, status=status.HTTP_200_OK)
#         except Exception as e:
#             return Response({"message": "Failed to fetch symptoms", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
