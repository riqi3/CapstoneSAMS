from api.modules.cpoe.models import Comment, Prescription, Medicine
from rest_framework import serializers

'''
This serializer will convert Comment objects into jsons.
'''
class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = ['comNum', 'content', 'account', 'health_record']

'''
This serializer will convert Prescription objects into jsons.
'''
class PrescriptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Prescription
        fields = ['presID', 'medicines', 'account', 
                #   'health_record', 
                  'patient', 
                #   , 'disease'
                'illness',
            'isDeleted', 
                  ]

'''
This serializer will convert Medicine objects into jsons.
'''
class MedicineSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medicine
        fields = ['drugId', 'drugCode', 'drugName']
