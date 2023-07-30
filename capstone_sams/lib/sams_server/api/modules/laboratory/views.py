from django.shortcuts import get_object_or_404
from rest_framework import viewsets
from rest_framework.decorators import api_view
from rest_framework.response import Response
import json
from rest_framework import status
 
from api.modules.laboratory.models import LabResult
from api.modules.laboratory.serializer import LabResultSerializer


class LabResultView(viewsets.ModelViewSet):

    @api_view(['GET'])
    def fetch_pdf(request):
        try:
            queryset = LabResult.objects.all()
            serializer = LabResultSerializer(queryset, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch pdfs.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
        
    @api_view(['GET'])
    def fetch_pdf_by_id(request, pdfId):
        try:
            queryset = LabResult.objects.filter(pk=pdfId)
            serializer = LabResultSerializer(queryset, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"message": "Failed to fetch pdf.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
    
    # @api_view(['GET'])
    # def fetch_pdf_through_prescription(request, title):
    #     try:
    #         pdfId = LabResult.objects.get(pk=pdfId)
    #         pdf_title = LabResult.objects.filter(prescription=prescription)
    #         medicines = [prescribed_medicine.medicine for prescribed_medicine in prescribed_medicines]
    #         serializer = MedicineSerializer(medicines, many=True)
    #         return Response(serializer.data, status=status.HTTP_200_OK)
    #     except Exception as e:
    #          return Response({"message": "Failed to fetch medicine.", "error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
            
