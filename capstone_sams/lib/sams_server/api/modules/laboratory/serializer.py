from api.modules.laboratory.models import LabResult, JsonLabResult
from rest_framework import serializers

class LabResultSerializer(serializers.ModelSerializer):
    class Meta:
        model = LabResult
        fields = ["pdfId", "title", 'comment', 'pdf']

class JsonLabResultSerializer(serializers.ModelSerializer):
    class Meta:
        model = JsonLabResult
        fields = ['jsonId', 'jsonData', 'createdAt']