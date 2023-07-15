from rest_framework import viewsets
from rest_framework.decorators import api_view
from rest_framework.response import Response
import json
from rest_framework import status

from api.modules.user.Account import Account
from api.modules.user.serializers import AccountSerializer
from api.modules.patient.serializers import Health_Record
from api.modules.cpoe.models import Comment, Medicine, Prescribed_Medicine, Prescription
from api.modules.cpoe.serializers import CommentSerializer, MedicineSerializer, PrescriptionSerializer


class CommentView(viewsets.ModelViewSet):

    @api_view(['POST'])
    def create_comment(request, accountId, recordNum):
        try:
            comment_data = json.loads(request.body)
            account = Account.objects.get(pk=accountId)
            record = Health_Record.objects.get(pk=recordNum)
            comment = Comment.objects.create(
                content = comment_data['content'],
                account = account,
                health_record = record
            )
            return Response({"message": "Comment successfully created"}, status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response({"message": "Failed to create comment"}, status=status.HTTP_400_BAD_REQUEST)
    
    @api_view(['GET'])
    def fetch_comments(request):
        try:
            queryset = Comment.objects.all()
            serializer = CommentSerializer(queryset, many = True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch comments.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
    
    @api_view(['GET'])
    def fetch_comments_by_account_id(request, accountId):
        try:
            account = Account.objects.get(pk=accountId)
            queryset = Comment.objects.filter(account=account)

            account_serializer = AccountSerializer(account)
            serializer = CommentSerializer(queryset, many = True)
            response_data = {
                'comments' : serializer.data,
                'account': account_serializer.data
            }
            return Response(response_data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch comments.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
        
    @api_view(['PUT'])
    def update_comment(request, comNum):
        try:
            comments_data = json.loads(request.body)
            comment = Comment.objects.get(pk = comNum)
            comment.content = comments_data['content']
            comment.save()
            return Response({"message": "Comment successfully update"}, status=status.HTTP_204_NO_CONTENT)
        except Exception as e:
            return Response({"message": "Failed to update comment", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
    
    @api_view(['DELETE'])
    def delete_comment(request, comNum):
        try:
            comment = Comment.objects.get(pk = comNum)
            comment.delete()
            return Response({"message": "Comment successfully deleted"}, status=status.HTTP_204_NO_CONTENT)
        except Exception as e:
             return Response({"message": "Failed to delete comment", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)



class MedicineView(viewsets.ModelViewSet):

    @api_view(['GET'])
    def fetch_medicine(request):
        try:
            queryset = Medicine.objects.all()
            serializer = MedicineSerializer(queryset, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch medicines.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
        
    @api_view(['GET'])
    def fetch_medicine_by_id(request, drugID):
        try:
            queryset = Medicine.objects.filter(pk=drugID)
            serializer = MedicineSerializer(queryset, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch medicine.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
    
    @api_view(['GET'])
    def fetch_medicine_through_prescription(request, presNum):
        try:
            prescription = Prescription.objects.get(pk=presNum)
            prescribed_medicines = Prescribed_Medicine.objects.filter(prescription=prescription)
            medicines = [prescribed_medicine.medicine for prescribed_medicine in prescribed_medicines]
            serializer = MedicineSerializer(medicines, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
             return Response({"message": "Failed to fetch medicine.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
            

class PrescriptionView(viewsets.ViewSet):
    @api_view(['GET'])
    def fetch_prescription_by_ids(request, accountId, recordNum):
        try:
            account = Account.objects.get(pk=accountId)
            record = Health_Record.objects.get(pk=recordNum)
            prescription = Prescription.objects.get(account = account, health_record = record)
            serializer = PrescriptionSerializer(prescription)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
             return Response({"message": "Failed to fetch prescription", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
