from rest_framework import serializers
from .models import HealthSymptom

class HealthSymptomSerializer(serializers.ModelSerializer):
    class Meta:
        model = HealthSymptom
        fields = '__all__' 