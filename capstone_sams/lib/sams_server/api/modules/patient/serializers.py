from api.modules.patient.models import Patient, Health_Record
from rest_framework import serializers


class PatientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Patient
        fields = [
            "patientID",
            "firstName",
            "middleName",
            "lastName",
            "age",
            "gender",
            "birthDate",
            "registration",
            "phone",
            "email",
        ]


class HealthRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = Health_Record
        fields = ["recordNum", "symptoms", "diseases", "patient"]


# class SymptomSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Symptom
#         fields = ["sympNum", "symptom"]
