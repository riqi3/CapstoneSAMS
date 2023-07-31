from django.shortcuts import get_object_or_404
from rest_framework import viewsets
from rest_framework.decorators import api_view
from rest_framework.response import Response
import json
import os
from tabula.io import read_pdf
import pandas as pd
from django.http import JsonResponse
from rest_framework import status
from django.http import HttpResponse
from api.modules.laboratory.models import LabResult
from api.modules.laboratory.serializer import LabResultSerializer
from rest_framework.views import APIView
from api.admin import LabResultAdmin


class ProcessPdf(APIView):
    @api_view(['POST'])
    def post(request):
        s = LabResultAdmin.get_urls()
        # base_dir = os.path.dirname(__file__)
        # pdf_root = os.path.join(base_dir, 'upload-pdf/')
        # pdf_file = LabResult.objects.last()
        # file_path = pdf_file.file.path
        df = read_pdf(s, pages='all', encoding='cp1252')
        result = df[1].to_json(orient='records')
        return JsonResponse({'result':result}) 
        # pdf_path = request.POST.get('pdfPath')



class LabResultView(viewsets.ModelViewSet):

    # @api_view(['POST'])
    # def process_pdf(request):
    #     # pdf_path = 'upload-pdf/cbc3.pdf'
    #     pdf_path = request.POST.get('pdfPath')
    #     df = read_pdf(pdf_path, pages='all', encoding='cp1252')
    #     result = df[1].to_json(orient='records')
    #     return JsonResponse({'result':result})
    
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
            
