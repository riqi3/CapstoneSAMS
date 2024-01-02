from api.modules.patient.models import Patient, Health_Record, Contact_Person
from rest_framework import serializers

"""
This serializer will convert Patient objects into jsons.
"""


class PatientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Patient
        fields = [
            "firstName",
            "middleInitial",
            "lastName",
            "age",
            "gender",
            "birthDate",
            'department',
            'course',
            'yrLevel',
            'studNumber',
            'address',
            'height',
            'weight',
            "registration",
            "phone",
            "email", 
            'assignedPhysician',
        ]


"""
This serializer will convert Health_Record objects into jsons.
"""


class HealthRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = Health_Record
        fields = [
            'recordNum',
            'symptoms',
            'diseases',
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
            'contactNum',
            'contactAddress', 
            'patient',
        ]