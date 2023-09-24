from api.modules.laboratory.models import LabResult, JsonLabResult
from rest_framework import serializers

class LabResultSerializer(serializers.ModelSerializer):
    class Meta:
        model = LabResult
        fields = ['patient', "title", 'comment', 'pdf']

class JsonLabResultSerializer(serializers.ModelSerializer):
    class Meta:
        model = JsonLabResult
        fields = ['jsonId', 'labresultTitles', 'jsonTables',  'createdAt','labresult', 'title', 'comment', 'patient']