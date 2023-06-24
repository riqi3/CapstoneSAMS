from rest_framework import serializers
from api.models import Account

class AccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = ['accountID', 'username', 'password',
                  'firstName', 'lastName', 'accountRole',
                  'is_active', 'is_staff', 'is_superuser']
