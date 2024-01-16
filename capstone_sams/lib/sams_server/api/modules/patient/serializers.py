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
            "birthDate",
            # 'department',
            'course',
            'yrLevel',
            'studNumber',
            'address',
            'height',
            'weight',
            # "registration",
            "phone",
            "email", 
            'assignedPhysician',
        ]


"""
This serializer will convert Health_Record objects into jsons.
"""


class MedicalRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medical_Record
        fields = [
            'recordNum',
            # 'symptoms',
            # 'diseases',
            'illnesses',
            'allergies',
            'pastDisease',
            'familyHistory',
            'lastMensPeriod',
            'patient',
        ]

class ContactPersonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Contact_Person
        fields = [
            'contactId',
            'fullName',
            'phone',
            'address', 
            'patient',
        ]

class PresentIllnessSerializer(serializers.ModelSerializer):
    class Meta:
        model = Present_Illness,
        fields = [
            'illnessNum',
            'complaint',
            'findings',
            'diagnosis',
            'treatment',
            'patient'
        ]