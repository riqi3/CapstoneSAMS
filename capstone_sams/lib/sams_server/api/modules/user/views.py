from rest_framework import viewsets
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import AllowAny
from django.contrib.auth import authenticate

import json

from api.modules.user.models import Personal_Note, Account
from api.modules.user.serializers import PersonalNoteSerializer


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
            return Response({'access_token': access_token, 'refresh_token': refresh_token})
        else:
            # If authentication fails, return an error response
            return Response({'error': 'Invalid credentials'}, status=400)
    

class PersonalNotesView(viewsets.ModelViewSet):
    
    @api_view(['GET'])
    def fetch_personal_notes(request, accountID):
        try:
            personal_notes = Personal_Note.objects.filter(account__pk=accountID)
            serializer = PersonalNoteSerializer(personal_notes, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch personal notes"}, status=status.HTTP_400_BAD_REQUEST)

    @api_view(['POST']) 
    def create_personal_note(request):
        try:
            notes_data = json.loads(request.body)
            account_id = notes_data['account']
            account = Account.objects.get(accountID = account_id)
            note = Personal_Note.objects.create(
                title = notes_data['title'],
                content = notes_data['content'],
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
            note.save()
            return Response({"message": "Note successfully update"}, status=status.HTTP_204_NO_CONTENT)
        except Exception as e:
            return Response({"message": "Failed to update note", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

    @api_view(['DELETE'])
    def delete_personal_note(request, noteNum):
        try:
            note = Personal_Note.objects.get(pk=noteNum)
            note.delete()
            return Response({"message": "Note successfully deleted"}, status=status.HTTP_204_NO_CONTENT)
        except Exception as e:
             return Response({"message": "Failed to delete note", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
        
