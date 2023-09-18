from api.modules.cpoe.models import Comment, Prescription, Medicine
from rest_framework import serializers


class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = ['comNum', 'content', 'account', 'health_record']

class PrescriptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Prescription
        fields = ['presNum', 'medicines', 'account', 'health_record']

class MedicineSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medicine
        fields = ['drugId', 'drugCode', 'drugName']
