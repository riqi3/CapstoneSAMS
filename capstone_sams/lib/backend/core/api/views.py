from django.shortcuts import render
from django.utils import timezone
import json
import statistics
from api.models import Account
from api.serializers import AccountSerializer
from rest_framework import viewsets
from rest_framework.decorators import api_view
from rest_framework.response import Response

# Create your views here.
class AccountView(viewsets.ModelViewSet):

    @api_view(['POST'])
    def register(request):
        account_data = json.loads(request.body)
        account = Account.objects.create(
            accountID = account_data['accountID'],
            username = account_data['username'],
            password = account_data['password'],
            firstName = account_data['firstName'],
            lastName = account_data['lastName'],
            accountRole = account_data['accountRole']
        )
        serializer = AccountSerializer(account)
        return Response(serializer.data)

    @api_view(['GET'])
    def getAccounts(request):
        queryset = Account.objects.all()
        serializer = AccountSerializer(queryset, many=True)
        return Response(serializer.data)
    
    @api_view(['POST'])
    def getLogIn(request):
        username = request.data.get('username')
        password = request.data.get('password')
    
        # validate username and password
        if not username or not password:
            return Response({'error': 'Invalid credentials'}, status=statistics.HTTP_401_UNAUTHORIZED)

        try:
            account = Account.objects.get(username = username, password = password)
            if account:
                account.last_login = timezone.now()
                account.save()
                serializer = AccountSerializer(account)
                return Response(serializer.data)
            else:
                return Response({'error': 'Invalid credentials'}, status=statistics.HTTP_401_UNAUTHORIZED)
        except Account.DoesNotExist:
            return Response({'error': 'Invalid credentials'}, status=statistics.HTTP_401_UNAUTHORIZED)
    
    @api_view(['POST'])
    def updateAccount(request):
        account_data = json.loads(request.body)
        account_id = account_data['accountID']
        account = Account.objects.get(pk = account_id)
        account.username = account_data['username']
        account.password = account_data['password']
        account.firstName = account_data['firstName']
        account.lastName =  account_data['lastName']
        account.accountRole = account_data['accountRole']
        account.is_active = account_data['is_active']
        account.is_staff = account_data['is_staff']
        account.is_superuser = account_data['is_superuser']
        account.save()