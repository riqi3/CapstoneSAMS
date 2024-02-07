
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
            studentNumber = patient_data['studNumber']
            if studentNumber and Patient.objects.filter(studNumber=studentNumber):
                return Response({"message": "Patient with this student number already exists."}, status=status.HTTP_400_BAD_REQUEST)
            patient = Patient.objects.create(
                patientID=patient_data['patientID'], 
                firstName=patient_data['firstName'],
                middleInitial=patient_data['middleInitial'],
                lastName=patient_data['lastName'],
                age=patient_data['age'],
                gender=patient_data['gender'],
                patientStatus=patient_data['patientStatus'],
                birthDate=patient_data['birthDate'], 
                course=patient_data['course'],
                yrLevel=patient_data['yrLevel'],
                studNumber=patient_data['studNumber'],
                address=patient_data['address'],
                height=patient_data['height'],
                weight=patient_data['weight'], 
                phone=patient_data['phone'],
                email=patient_data['email'], 
            )
            accountID = patient_data['account']
            account = Account.objects.get(accountID=accountID)
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

    
     
    # @api_view(['GET'])
    # def fetch_patient_by_accountid(request, accountID):
    #     try:
    #         account = Account.objects.get(pk=accountID)
    #         patient = Patient.objects.filter(assignedPhysician=account)
    #         serializer = PatientSerializer(patient, many=True)
    #         return Response(serializer.data, status=status.HTTP_200_OK)
    #     except Medical_Record.DoesNotExist:
    #         return Response({"message": "Patient does not exist."}, status=status.HTTP_404_NOT_FOUND)
    
    
    '''
    This view allow the user to update a patient based on the patient's id.
    A data log will be automatically generated for reference.
    Certain to exception handlers were coded to ensure continued operations.
    '''
    @api_view(['PUT'])
    def update_patient(request):
        try:
            patient_data = json.loads(request.body)
            # assignedID = patient_data['assignedPhysician']
            patient = Patient.objects.get(pk=patient_id)
            patient_id = patient_data['patientID']
            patient.firstName = patient_data['firstName']
            patient.middleInitial = patient_data['middleInitial']
            patient.lastName = patient_data['lastName']
            patient.age = patient_data['age']
            patient.gender = patient_data['gender']
            patient.patientStatus = patient_data['patientStatus']
            patient.birthDate = patient_data['birthDate'] 
            patient.course=patient_data['course']
            patient.yrLevel=patient_data['yrLevel']
            patient.studNumber=patient_data['studNumber']
            patient.address=patient_data['address']
            patient.height=patient_data['height']
            patient.weight=patient_data['weight']
            patient.phone = patient_data['phone']
            patient.email = patient_data['email']
            # patient.assignedPhysician = assignedID
            patient.save()
            accountID = patient_data['account']
            account = Account.object.get(pk=accountID)
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
    
    @api_view(['POST'])
    # @permission_classes([IsAuthenticated])
    def delete_patient(request, patientID):
        try:
            patient = Patient.objects.get(pk=patientID)
            data = json.loads(request.body)
            accountID = data['accountID']
            patient.isDeleted = True
            patient.save()
            account = Account.objects.get(pk=accountID)
            data_log = Data_Log.objects.create(
                event = f"{account.username} deleted patient id {patient.patientID}",
                type = "User Soft Delete Patient Data",
                account = account
            )
            return Response({"message": "Patient deleted successfully."}, status=status.HTTP_204_NO_CONTENT)
        except Exception as e:
            return Response({"message": "Failed to delete patient.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
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
   

    @api_view(['POST'])
    def create_health_record(request):
        try:
            record_data = json.loads(request.body)
            patientID = record_data['patient'] 
            patient = Patient.objects.get(patientID=patientID)
            record = Medical_Record.objects.create( 
                illnesses = record_data['illnesses'],
                allergies = record_data['allergies'],
                pastDiseases = record_data['pastDiseases'],
                familyHistory = record_data['familyHistory'],
                lastMensPeriod = record_data['lastMensPeriod'],
                patient = patient
            )
            return Response({"message": "Health record created successfully."}, status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response({"message": "Failed to create health record.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
        
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
            record.pastDiseases = record_data['pastDiseases']
            record.familyHistory = record_data['familyHistory']
            record.lastMensPeriod = record_data['lastMensPeriod']
            record.save()
            return Response({"message": "Health Record updated successfully."}, status=status.HTTP_200_OK)
        except Medical_Record.DoesNotExist:
            return Response({"message": "Health Record does not exist."}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"message": "Failed to update health record.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

class ContactPersonView(viewsets.ViewSet):
    @api_view(['POST'])
    def create_contact_person(request):
        try:
            contact_data = json.loads(request.body)
            patientID = contact_data['patient']
            patient = Patient.objects.get(patientID=patientID)
            contact = Contact_Person.objects.create(
                fullName = contact_data['fullName'],
                phone = contact_data['phone'],
                address = contact_data['address'],
                patient = patient
            )
            return Response({"message": "Contact record created successfully."}, status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response({"message": "Failed to create contact record.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST) 
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
            queryset = Present_Illness.objects.all()
            serializer = PresentIllnessSerializer(queryset, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch complaints.", "error": str(e)}, status=status.HTTP_404_NOT_FOUND)

    @api_view(['GET'])
    def fetch_complaint_by_id(request, patientID):
        try:
            patient = Patient.objects.get(pk=patientID)
            complaint = Present_Illness.objects.filter(patient=patient)
            serializer = PresentIllnessSerializer(complaint, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except PresentIllnessSerializer.DoesNotExist:
            return Response({"message": "Complaint does not exist."}, status=status.HTTP_404_NOT_FOUND)
    
    @api_view(['POST'])
    def create_complaint(request, patientID, accountID):
        try:
            patient = Patient.objects.get(pk=patientID)
            # accountID = account.accountID
            account = Account.objects.get(pk=accountID)
            illness_data = json.loads(request.body)
            illness = Present_Illness.objects.create(
                illnessName = illness_data['illnessName'],
                complaint = illness_data['complaint'],
                findings = illness_data['findings'],
                diagnosis = illness_data['diagnosis'],
                treatment = illness_data['treatment'],
                created_at = illness_data['created_at'],
                updated_at = illness_data['updated_at'],
                patient = patient,
                created_by = account
            )
            return Response({"message": "Complaint created successfully."}, status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response({"message": "Failed to create complaint.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
    
    @api_view(['PUT'])
    def update_complaint(request, illnessID, accountID):
        try:
            present_illness = Present_Illness.objects.get(pk = illnessID)
            illness_data = json.loads(request.body)
            present_illness.illnessName = illness_data['illnessName']
            present_illness.complaint = illness_data['complaint']
            present_illness.findings = illness_data['findings']
            present_illness.diagnosis = illness_data['diagnosis']
            present_illness.treatment = illness_data['treatment']
            present_illness.created_at = illness_data['created_at']
            present_illness.updated_at = illness_data['updated_at'] 
            present_illness.save()
            account = Account.objects.get(pk=accountID) 
            return Response({"message": "Complaint updated successfully."}, status=status.HTTP_200_OK)
        except Present_Illness.DoesNotExist:
            return Response({"message": "Complaint does not exist."}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"message": "Failed to update complaint.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

    # @api_view(['POST'])
    # # @permission_classes([IsAuthenticated])
    # def delete_complaint(request):
    #     try:
    #         data = json.loads(request)
    #         illnessID = data['illnessID']
    #         accountID = data['accountID']
    #         complaint = Present_Illness.objects.get(pk=illnessID)
    #         complaint.isDeleted = True
    #         complaint.save()
    #         account = Account.object.get(pk=accountID)
    #         data_log = Data_Log.objects.create(
    #             event = f"{account.username} deleted complaint id {complaint.illnessID}",
    #             type = "User Soft Delete Complaint Data",
    #             account = account
    #         )
    #         return Response({"message": "Complaint deleted successfully."}, status=status.HTTP_204_NO_CONTENT)
    #     except Exception as e:
    #         return Response({"message": "Failed to delete complaint.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

    @api_view(['POST'])
    # @permission_classes([IsAuthenticated])
    def delete_complaint(request):
        try:
            data = json.loads(request.body)
            illnessID = data['illnessID']
            accountID = data['accountID']
            complaint = Present_Illness.objects.get(pk=illnessID)
            complaint.isDeleted = True
            complaint.save()
            account = Account.objects.get(pk=accountID)
            data_log = Data_Log.objects.create(
                event = f"{account.username} deleted complaint id {complaint.illnessID}",
                type = "User Soft Delete Complaint Data",
                account = account
            )
            return Response({"message": "Complaint deleted successfully."}, status=status.HTTP_204_NO_CONTENT)
        except Exception as e:
            return Response({"message": "Failed to delete complaint.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)