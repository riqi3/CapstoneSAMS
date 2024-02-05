from api.modules.patient.models import Patient, Medical_Record, Contact_Person, Present_Illness
from rest_framework import serializers

"""
This serializer will convert Patient objects into jsons.
"""


class PatientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Patient
        fields = [
            'patientID',
            "firstName",
            "middleInitial",
            "lastName",
            "age",
            "gender",
            'patientStatus',
            "birthDate", 
            'course',
            'yrLevel',
            'studNumber',
            'address',
            'height',
            'weight', 
            "phone",
            "email",  
            'isDeleted',
        ]


"""
This serializer will convert Health_Record objects into jsons.
"""


class MedicalRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medical_Record
        fields = [
            'recordID', 
            'illnesses',
            'allergies',
            'pastDiseases',
            'familyHistory',
            'lastMensPeriod',
            'patient',
        ]

class ContactPersonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Contact_Person
        fields = [
            'contactID',
            'fullName',
            'phone',
            'address', 
            'patient',
        ]

class PresentIllnessSerializer(serializers.ModelSerializer):
    class Meta:
        model = Present_Illness
        fields = [
            'illnessID',
            'illnessName',
            'complaint',
            'findings',
            'diagnosis',
            'treatment',
            'created_at',
            'updated_at',
            'patient',
            'created_by',
            'isDeleted',
        ]