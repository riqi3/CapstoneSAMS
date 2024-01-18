
from django.shortcuts import get_object_or_404
from rest_framework import viewsets
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
import json
from rest_framework import status
from api.modules.user.models import Account, Data_Log
from api.modules.patient.models import Patient, Medical_Record, Contact_Person, Present_Illness
from api.modules.patient.serializers import PatientSerializer, MedicalRecordSerializer, ContactPersonSerializer, PresentIllnessSerializer

'''
This view represent all the functions necessary to conduct
operations related to Patient objects.
'''
class PatientView(viewsets.ModelViewSet):


    '''
    This view allow the user to create a new patient and store it into the 
    database.
    In addition, it creates a health record link to the new patient and also
    create data log for reference.
    Certain to exception handlers were coded to ensure continued operations.
    '''
    @api_view(['POST'])
    def create_patient(request):
        try:
            patient_data = json.loads(request.body)
            accountID = patient_data['assignedPhysician']
            physician = Account.objects.get(pk=accountID)
            patient = Patient.objects.create(
                patientID=patient_data['patientID'], 
                firstName=patient_data['firstName'],
                middleInitial=patient_data['middleInitial'],
                lastName=patient_data['lastName'],
                age=patient_data['age'],
                gender=patient_data['gender'],
                birthDate=patient_data['birthDate'], 
                course=patient_data['course'],
                yrLevel=patient_data['yrLevel'],
                studNumber=patient_data['studNumber'],
                address=patient_data['address'],
                height=patient_data['height'],
                weight=patient_data['weight'], 
                phone=patient_data['phone'],
                email=patient_data['email'],
                assignedPhysician=physician
            )
            patient_instance = get_object_or_404(Patient, pk=patient_data['patientID'])
            record = Medical_Record.objects.create( 
                illnesses = patient_data['illnesses'],
                pastDiseases = patient_data['pastDiseases'],
                allergies = patient_data['allergies'],
                familyHistory = patient_data['familyHistory'],
                lastMensPeriod = patient_data['lastMensPeriod'],
                patient = patient_instance
            )
            contact = Contact_Person.objects.create(
                fullName = patient_data['fullName'],
                phone = patient_data['phone'],
                address = patient_data['address'],
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

    '''
    This view allow the user to fetch all patients currently stored into the system.
    Certain to exception handlers were coded to ensure continued operations.
    '''
    @api_view(['GET'])
    # @permission_classes([IsAuthenticated])
    def fetch_patients(request):
        try:
            queryset = Patient.objects.all()
            serializer = PatientSerializer(queryset, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch patients.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

    '''
    This view allow the user to fetch a certain patient base on the patient's id.
    Certain to exception handlers were coded to ensure continued operations.
    '''
    @api_view(['GET'])
    # @permission_classes([IsAuthenticated])
    def fetch_patient_by_id(request, patientID):
        try:
            queryset = Patient.objects.filter(pk=patientID)
            serializer = PatientSerializer(queryset.first())
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch patients.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

    '''
    This view allow the user to update a patient based on the patient's id.
    A data log will be automatically generated for reference.
    Certain to exception handlers were coded to ensure continued operations.
    '''
    @api_view(['PUT'])
    def update_patient(request):
        try:
            patient_data = json.loads(request.body)
            patient_id = patient_data['patientID']
            patient = Patient.objects.get(pk=patient_id)
            patient.firstName = patient_data['firstName']
            patient.middleInitial = patient_data['middleInitial']
            patient.lastName = patient_data['lastName']
            patient.age = patient_data['age']
            patient.gender = patient_data['gender']
            patient.birthDate = patient_data['birthDate']
            patient.department = patient_data['department']
            patient.course=patient_data['course']
            patient.yrLevel=patient_data['yrLevel']
            patient.studNumber=patient_data['studNumber']
            patient.address=patient_data['address']
            patient.height=patient_data['height']
            patient.weight=patient_data['weight']
            patient.phone = patient_data['phone']
            patient.email = patient_data['email']
            patient.assignedPhysician = patient_data['assignedPhysician']
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
'''
This view represent all the functions necessary to conduct
operations related to Medical_Record objects.
'''
class MedicalRecordView(viewsets.ViewSet):

    '''
    This view allow the user to fetch a certain patient's record base on the patient's id.
    Certain to exception handlers were coded to ensure continued operations.
    '''
    @api_view(['GET'])
    def fetch_record_by_id(request, patientID):
        try:
            patient = Patient.objects.get(pk=patientID)
            record = Medical_Record.objects.get(patient=patient)
            serializer = MedicalRecordSerializer(record)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Medical_Record.DoesNotExist:
            return Response({"message": "Health Record does not exist."}, status=status.HTTP_404_NOT_FOUND)
    
    @api_view(['GET'])
    def fetch_contact_by_id(request, patientID):
        try:
            patient = Patient.objects.get(pk=patientID)
            contact = Contact_Person.objects.get(patient=patient)
            serializer = ContactPersonSerializer(contact)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Medical_Record.DoesNotExist:
            return Response({"message": "Health Record does not exist."}, status=status.HTTP_404_NOT_FOUND)
    

    @api_view(['PUT'])
    def update_health_record(request, patientID):
        try:
            patient = Patient.objects.get(pk=patientID)
            record = Medical_Record.objects.get(patient=patient)
            record_data = json.loads(request.body)
            record.symptoms = record_data['symptoms']
            record.diseases = record_data['symptoms']
            record.illnesses = record_data['illnesses']
            record.allergies = record_data['allergies']
            record.pastDisease = record_data['pastDisease']
            record.familyHistory = record_data['familyHistory']
            record.lastMensPeriod = record_data['lastMensPeriod']
            record.save()
            return Response({"message": "Health Record updated successfully."}, status=status.HTTP_200_OK)
        except Medical_Record.DoesNotExist:
            return Response({"message": "Health Record does not exist."}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"message": "Failed to update health record.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

class ContactPersonView(viewsets.ViewSet):
    @api_view(['PUT'])
    def update_contact_person(request, patientID):
        try:
            patient = Patient.objects.get(pk=patientID)
            contact = Contact_Person.objects.get(patient=patient)
            contact_data = json.loads(request.body)
            contact.fullName = contact_data['fullName']
            contact.contactNum = contact_data['contactNum']
            contact.contactAddress = contact_data['contactAddress']
            contact.save()
            return Response({"message": "Contact updated successfully."}, status=status.HTTP_200_OK)
        except Contact_Person.DoesNotExist:
            return Response({"message": "Contact does not exist."}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"message": "Failed to update contact.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
        
class PresentIllnessView(viewsets.ViewSet):
    @api_view(['GET'])
    def fetch_complaints(request):
        try:
            complaints = Present_Illness.objects.all()
            serializer = PresentIllnessSerializer(complaints)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch complaints. str{e}"}, status=status.HTTP_404_NOT_FOUND)

    @api_view(['GET'])
    def fetch_complaint_by_id(request, illnessNum):
        try:
            complaint = Present_Illness.objects.get(pk=illnessNum)
            serializer = PresentIllnessSerializer(complaint)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except PresentIllnessSerializer.DoesNotExist:
            return Response({"message": "Complaint does not exist."}, status=status.HTTP_404_NOT_FOUND)
    
    @api_view(['POST'])
    def create_complaint(request, patientID):
        try:
            patient = Patient.objects.get(pk=patientID)
            illness_data = json.loads(request.body)
            illness = Present_Illness.objects.create(
                complaint = illness_data['complaint'],
                findings = illness_data['findings'],
                diagnosis = illness_data['diagnois'],
                treatment = illness_data['treatment'],
                patient = patient
            )
            return Response({"message": "Complaint created successfully."}, status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response({"message": "Failed to create complaint.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
    
    @api_view(['PUT'])
    def update_complaint(request, illnessNum):
        try:
            present_illness = Present_Illness.objects.get(pk = illnessNum)
            illness_data = json.loads(request.body)
            present_illness.complaint = illness_data['complain']
            present_illness.findings = illness_data['findings']
            present_illness.diagnosis = illness_data['diagnosis']
            present_illness.treatment = illness_data['treatment']
            present_illness.save()
            return Response({"message": "Complaint updated successfully."}, status=status.HTTP_200_OK)
        except Present_Illness.DoesNotExist:
            return Response({"message": "Complaint does not exist."}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"message": "Failed to update complaint.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)