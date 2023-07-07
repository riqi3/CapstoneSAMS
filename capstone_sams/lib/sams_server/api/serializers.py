from api.models import Account, Patient, Data_Logs, Health_Record, Comment, Prescription, Medicine, Personal_Notes
from rest_framework import serializers
from django.contrib.auth import get_user_model

class AccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = ['accountID', 'username', 'password',
                  'firstName', 'lastName', 'accountRole',
                  'is_active', 'is_staff', 'is_superuser']
        extra_kwargs = {'password': {'write_only': True, 'required': False}}

        def create(self, validated_data):
            User = get_user_model()
            user = User.objects.all()
            return user

class PatientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Patient
        fields = ['patientID', 'firstName', 'middleName',
                  'lastName', 'gender', 'birthDate',
                  'phone', 'email']

class DataLogsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Data_Logs
        fields = ['logNum', 'event', 'date', 'account']

class HealthRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = Health_Record
        fields = ['recordNum', 'patient']

class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = ['comNum', 'content', 'account', 'health_record']

class PrescriptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Prescription
        fields = ['presNum', 'dosage', 'timeFrame', 'amount', 'account', 'health_record']

class MedicineSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medicine
        fields = ['drugId', 'drugCode', 'drugName']

class PersonalNotesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Personal_Notes
        fields = ['noteNum', 'title', 'content', 'account']
   