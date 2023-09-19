from api.modules.patient.models import Patient, Health_Record
from rest_framework import serializers

'''
This serializer will convert Patient objects into jsons.
'''
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

'''
This serializer will convert Health_Record objects into jsons.
'''
class HealthRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = Health_Record
        fields = ["recordNum", "symptoms", "diseases", "patient"]


# class SymptomSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Symptom
#         fields = ["sympNum", "symptom"]
