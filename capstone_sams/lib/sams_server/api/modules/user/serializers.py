
from api.modules.user.models import Account, Personal_Note, Data_Log
from django.contrib.auth import get_user_model
from rest_framework import serializers
from PIL import Image, ImageDraw, ImageFont 
import random   
import os

'''
This serializer will convert Account objects into jsons.
'''
class AccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = ['accountID', 'profile_photo', 'username', 'password',
                  'firstName', 'lastName', 'accountRole', 'token',
                  'is_active', 'is_staff', 'is_superuser']
        extra_kwargs = {'password': {'write_only': True, 'required': False}}
 

      
        def create(self, validated_data):
            User = get_user_model()
            user = User.objects.all()
            return user
        

'''
This serializer will convert Personal_Note objects into jsons.
'''
class PersonalNoteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Personal_Note
        fields = ['noteNum', 'title', 'content', 'isDone', 'account']


'''
This serializer will convert Data_Log objects into jsons.
'''
class DataLogSerializer(serializers.ModelSerializer):
    class Meta:
        model = Data_Log
        fields = ['logNum', 'event', 'date', 'account']