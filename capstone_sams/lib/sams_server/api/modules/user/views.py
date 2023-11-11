from rest_framework import viewsets
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework import status
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import AllowAny, IsAuthenticated
from django.contrib.auth import authenticate, logout
from django.shortcuts import get_object_or_404
import json
from api.modules.user.models import Personal_Note, Account, Data_Log
from api.modules.user.serializers import PersonalNoteSerializer, AccountSerializer

'''
This view represent the ability to generate
and obtain a token.
Certain to exception handlers were coded to ensure continued operations.
'''
class ObtainTokenView(APIView):
    permission_classes = [AllowAny]

    @api_view(['POST'])
    def get_token(request):
        username = request.data.get('username')
        password = request.data.get('password')
        user = authenticate(username=username, password=password)

        if user is not None:
            refresh = RefreshToken.for_user(user)
            access_token = str(refresh.access_token)
            refresh_token = str(refresh)
            user.generate_token()
            return Response({'access_token': access_token, 'refresh_token': refresh_token}, status=status.HTTP_200_OK)
        else:
            return Response({'error': 'Invalid credentials'}, status=400)
    
'''
This view represent the ability for the user to login into the system.
The system will validate the username and password are valid.
In addition, it creates a data log for reference.
Certain to exception handlers were coded to ensure continued operations.
'''
class LogInView(viewsets.ModelViewSet):
    @api_view(['POST'])
    def photo(request):
        photo = request.data.get('profile_photo')

    @api_view(['GET'])
    def logout_view(request):
        logout(request)
        
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
        
    @api_view(['POST'])
    def logout(request, accountID):
        user = Account.objects.get(pk=accountID)
        data_log = Data_Log(
            event=f"User logged out: {user.username}",
            type="User Logout",
            account=user,
        )
        data_log.save()
        return Response({'message': 'Successfully logged out'}, status=200)

'''
This view represent all the function necessary to fetch
an Account object by its id.
'''
class AccountView(viewsets.ModelViewSet):
    @api_view(['GET'])
    def fetch_user_by_id(request, accountID):
        try:
            account = Account.objects.get(pk = accountID)
            serializer = AccountSerializer(account)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch account.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

'''
This view represent all the functions necessary to conduct
operations related to Personal_Note objects.
'''
class PersonalNotesView(viewsets.ModelViewSet):

    '''
    This view allow the user to fetch their inputted notes. It uses
    the user's id to determine the notes to be fetch.
    Certain to exception handlers were coded to ensure continued operations.
    '''
    @api_view(['GET'])
    @permission_classes([IsAuthenticated])
    def fetch_personal_notes(request, accountID):
        try:
            personal_notes = Personal_Note.objects.filter(account__pk=accountID)
            serializer = PersonalNoteSerializer(personal_notes, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch personal notes"}, status=status.HTTP_400_BAD_REQUEST)

    '''
    This view allow the user to create a new note and store it into the 
    database.
    In addition, it creates a data log for reference.
    Certain to exception handlers were coded to ensure continued operations.
    '''
    @api_view(['POST']) 
    @permission_classes([IsAuthenticated])
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


    
    '''
    This view allow the user to update their inputted personal note base on the note's
    number.
    In addition, a data log will be automatically generated for reference.
    Certain to exception handlers were coded to ensure continued operations.
    '''
    @api_view(['PUT'])
    @permission_classes([IsAuthenticated])
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
    
    '''
    This view allow the user to set the task as done or not.
    In addition, a data log will be automatically generated for reference.
    Certain to exception handlers were coded to ensure continued operations.
    '''
    @api_view(['PUT'])
    @permission_classes([IsAuthenticated])
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

    '''
    This view allow the user to delete their inputted personal note base on the note's
    number.
    Certain to exception handlers were coded to ensure continued operations.
    '''
    @api_view(['DELETE'])
    @permission_classes([IsAuthenticated])
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