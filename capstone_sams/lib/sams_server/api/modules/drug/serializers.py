from api.modules.drug.models import UploadDrugFile
from rest_framework import serializers

class UploadDrugFileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UploadDrugFile
        fields = '__all__'