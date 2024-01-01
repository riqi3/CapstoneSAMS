from rest_framework import serializers
from .models import DiagnosticFields

class DiagnosticFieldsSerializer(serializers.ModelSerializer):
    class Meta:
        model = DiagnosticFields
        fields = '__all__' 