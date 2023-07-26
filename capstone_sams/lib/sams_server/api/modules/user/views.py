from rest_framework import viewsets
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import AllowAny
from django.contrib.auth import authenticate
from django.shortcuts import get_object_or_404

import json

from api.modules.user.models import Personal_Note, Account, Data_Log
from api.modules.user.serializers import PersonalNoteSerializer, AccountSerializer


class ObtainTokenView(APIView):
    permission_classes = [AllowAny]

    @api_view(['POST'])
    def get_token(request):
        # Get the username and password from the request data
        username = request.data.get('username')
        password = request.data.get('password')

        # Authenticate the user using the provided credentials
        user = authenticate(username=username, password=password)

        # Check if the user is valid
        if user is not None:
            # Generate the access token and refresh token
            refresh = RefreshToken.for_user(user)
            access_token = str(refresh.access_token)
            refresh_token = str(refresh)

            # Optionally, you can also store the access_token in the Account model
            # If you want to store it, you can do it here:
            user.generate_token()

            # Return the access token and refresh token in the response
            return Response({'access_token': access_token, 'refresh_token': refresh_token}, status=status.HTTP_200_OK)
        else:
            # If authentication fails, return an error response
            return Response({'error': 'Invalid credentials'}, status=400)
    

class LogInView(viewsets.ModelViewSet):
    @api_view(['POST'])
    def login(request):
        username = request.data.get('username')
        password = request.data.get('password')

        user = authenticate(username=username, password=password)

        if user is not None:
            user.generate_token()

            data_log = Data_Log.objects.create(
                event = f"User logged in: {user.username}",
                type = "User Login",
                account = user
            )
            
            serializer = AccountSerializer(user)

            return Response(serializer.data, status=status.HTTP_200_OK)
        else:
            return Response({'error': 'Invalid credentials'}, status=400)



class PersonalNotesView(viewsets.ModelViewSet):

    @api_view(['GET'])
    def fetch_personal_notes(request, accountID):
        try:
        #     personal_notes = Personal_Note.objects.filter(account__pk=accountID)
        #     account = Account.objects.filter(pk=accountID)
        #     data_log = Data_Log.objects.create(
        #         event = f"User logged in: {account.username}",
        #         type = "User Login",
        #         account = account
        #     )
        
        # Retrieve the Account instance using get_object_or_404
            account = get_object_or_404(Account, pk=accountID)

        # Fetch personal notes for the given accountID
            personal_notes = Personal_Note.objects.filter(account__pk=accountID)

        # Create Data_Log instance after retrieving the username from the Account instance
            data_log = Data_Log.objects.create(
                event=f"User {account.username} fetches notes",
                type="User Fetches Personal Note",
                account=account
            )
            serializer = PersonalNoteSerializer(personal_notes, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch personal notes"}, status=status.HTTP_400_BAD_REQUEST)

    @api_view(['POST']) 
    def create_personal_note(request):
        try:
            notes_data = json.loads(request.body)
            account_id = notes_data['account']
            account = Account.objects.get(accountID=account_id)
            note = Personal_Note.objects.create(
                noteNum=notes_data['noteNum'],
                title=notes_data['title'],
                content=notes_data['content'],
                account=account,
                isDone=notes_data['isDone'],  
            )
            data_log = Data_Log.objects.create(
                event = f"{account.username} fetched personal notes",
                type = "User Fetch Personal Notes",
                account = account
            )
            return Response({"message": "Note successfully created"}, status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response({"message": "Failed to create note"}, status=status.HTTP_400_BAD_REQUEST)

    @api_view(['PUT'])
    def update_personal_note(request, noteNum):
        try:
            notes_data = json.loads(request.body)
            note = Personal_Note.objects.get(pk=noteNum)
            note.title = notes_data['title']
            note.content = notes_data['content']
            note.isDone = notes_data['isDone']  
            note.save()
            accountID = notes_data['account']
            account = get_object_or_404(Account, pk=accountID)
            data_log = Data_Log.objects.create(
                event = f"{account.username} updated personal note code {noteNum}",
                type = "User Update Personal Notes",
                account = account
            )
            return Response({"message": "Note successfully updated"}, status=status.HTTP_204_NO_CONTENT)
        except Exception as e:
            return Response({"message": "Failed to update note", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
    
    @api_view(['PUT'])
    def set_done(request, noteNum):
        try:
            notes_data = json.loads(request.body)
            note = Personal_Note.objects.get(pk=noteNum)
            note.isDone = notes_data['isDone']  
            note.save()
            accountID = notes_data['account']
            account = Account.objects.get(pk=accountID)
            data_log = Data_Log.objects.create(
                event = f"{account.username} set personal note as done code {noteNum}",
                type = "User Finished Personal Note",
                account = account
            )
            return Response({"message": "Note successfully updated"}, status=status.HTTP_204_NO_CONTENT)
        except Exception as e:
            return Response({"message": "Failed to update note", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

    @api_view(['DELETE'])
    def delete_personal_note(request, noteNum):
        try:
            note = Personal_Note.objects.get(noteNum = noteNum)
            data_log = Data_Log.objects.create(
                event = f"{note.account.username} deleted personal note code {noteNum}",
                type = "User Deleted Personal Note",
                account = note.account 
            )
            note.delete()
            return Response({"message": "Note successfully deleted"}, status=status.HTTP_204_NO_CONTENT)
        except Exception as e:
             return Response({"message": "Failed to delete note", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)