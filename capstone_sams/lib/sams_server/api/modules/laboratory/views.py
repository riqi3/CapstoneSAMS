from rest_framework import viewsets
from rest_framework.decorators import api_view
from rest_framework.response import Response
from tabula.io import read_pdf
from django.http import JsonResponse
from rest_framework import status
from django.http import HttpResponse
from api.modules.laboratory.models import LabResult, JsonLabResult
from api.modules.patient.models import Patient
from api.modules.laboratory.serializer import (
    LabResultSerializer,
    JsonLabResultSerializer,
)
from rest_framework.views import APIView
from django.shortcuts import render
from api.modules.laboratory.form import PdfImportLabResultForm
from django import forms
from django.contrib import admin, messages
from django.http import HttpResponseRedirect
import json


def cleanJsonTable(json_data):
    if isinstance(json_data, dict):
        cleaned_data = {}
        for key, value in json_data.items():
            if key == "text":
                cleaned_data[key] = value
            elif isinstance(value, (dict, list)):
                cleaned_data[key] = cleanJsonTable(value)
        return cleaned_data

    elif isinstance(json_data, list):
        return [cleanJsonTable(item) for item in json_data]

    else:
        return json_data


class LabResultForm(forms.ModelForm):
    class Meta:
        model = LabResult
        fields = "__all__"


class ProcessPdf(APIView):
    # def scan_pdf(request):
    #     # selected_pdfs = request.GET.get('selected_pdfs', '').split(',')
    #     # , {'selected_pdfs':selected_pdfs}
    #     return render(request, "laboratory/select/scan/pdf_scan.html")

    @api_view(["GET"])
    def fetch_json_pdf(request):
        try:
            queryset = JsonLabResult.objects.all()
            serializer = JsonLabResultSerializer(queryset, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response(
                {"message": "Failed to fetch json pdfs.", "error": str(e)},
                status=status.HTTP_400_BAD_REQUEST,
            )

    @api_view(["GET"])
    def fetch_json_pdf_by_id(request, jsonId):
        try:
            queryset = JsonLabResult.objects.filter(pk=jsonId)
            serializer = JsonLabResultSerializer(queryset, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response(
                {"message": "Failed to fetch json pdf.", "error": str(e)},
                status=status.HTTP_400_BAD_REQUEST,
            )
        
    @api_view(["GET"])
    def fetch_patient_labresult_by_id(request, patient):
        try:
            queryset = JsonLabResult.objects.filter(patient=patient)
            serializer = JsonLabResultSerializer(queryset, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response(
                {"message": "Failed to fetch labresult.", "error": str(e)},
                status=status.HTTP_400_BAD_REQUEST,
            )

    # def select_pdf(request):
    #     if request.method == 'POST':
    #         selected_pdfs = request.POST.getlist('item')
    #         pdf_contents = []

    #         for pdf_id in selected_pdfs:
    #             pdf = LabResult.objects.get(pdfId=pdf_id)
    #             with pdf.pdf.open('rb') as file:
    #                 reader = PyPDF2.PdfReader(file)
    #                 content = []

    #                 for page in reader.pages:
    #                     content.append(page.extract_text())

    #                 pdf_contents.append(content)
    #                 # print(pdf_contents)

    #     # Convert the extracted text to a JSON-parsed dictionary
    #         parsed_data = {'pdf_contents': pdf_contents}
    #         json_data = json.dumps(parsed_data)
    #         # print(json_data)
    #         return JsonResponse({'result': json.loads(json_data)})

    # PyPDF2
    # def select_pdf(request):
    #     if request.method == 'POST':
    #         selected_pdfs = request.POST.getlist('item')
    #         pdf_contents = []

    #         for pdf_id in selected_pdfs:
    #             pdf = LabResult.objects.get(pdfId=pdf_id)
    #             with pdf.pdf.open('rb') as file:
    #                 reader = PyPDF2.PdfReader(file)
    #                 content = []

    #                 for page in reader.pages:
    #                     content.append(page.extract_text())

    #                 pdf_contents.append(content)

    #         json_data = json.dumps(pdf_contents)
    #         print(json_data)
    #         # simplejson.loads('[%s]'%json_data[:-1])
    #         # text = json.loads(r'[' + json_data[:-1] + ']')
    #         return JsonResponse({'result': json.loads(json_data)})
 
    # tabnula
    def select_pdf(request,patient):
        if request.method == "POST":
            selected_pdfs = request.POST.getlist("item")
            pdf_contents = []

            for pdf_id in selected_pdfs:
                
                pdf_instance = LabResult.objects.get(pdfId=pdf_id)
                pdf_title = pdf_instance.title
                pdf_comment = pdf_instance.comment
                patient_id = pdf_instance.patient
                # test = pdf_instance.patient
                # patient_instance = Patient.objects.filter(patient=test)
                # patient_id = patient_instance.patientID
                # pdf_title= str(request.POST.get('title'))

                tables = read_pdf(
                    pdf_instance.pdf.path, pages="all", output_format="json"
                )
                table = tables[1]
                cleaned_data = cleanJsonTable(table)

                jsonLabResult = JsonLabResult(
                    jsonData=cleaned_data,
                    labresult=pdf_instance,
                    title=pdf_title,
                    comment=pdf_comment, 
                    patient=patient_id,
                )
                jsonLabResult.save()
                print(cleaned_data)

                pdf_contents.append(cleaned_data)
                json_data = json.dumps(pdf_contents)
            return JsonResponse({"result": json.loads(json_data)})
        else:
            pdf_list = LabResult.objects.filter(patient_id=patient)
            return render(
                request, "laboratory/select/pdf_select.html", {"pdf_list": pdf_list}
            )
 
    def upload_pdf1(request):
        if request.method == "POST":
            form = LabResultForm(request.POST, request.FILES)
            if form.is_valid():
                form.save()
            return HttpResponseRedirect("../select/<str:patient>/")

        else:
            form = LabResultForm()
            return render(request, "laboratory/upload/pdf_upload.html", {"form": form})

    def upload_pdf(self, request):
        if request.method == "POST":
            pdf_file = request.FILES["pdf_upload"]
            if not pdf_file.name.endswith(".pdf"):
                messages.warning(request, "The wrong file type was uploaded")
                return HttpResponseRedirect(request.path_info)

        form = PdfImportLabResultForm()
        data = {"form": form}
        return render(request, "admin/pdf_upload.html", data)

    @api_view(["POST"])
    def post(request):
        # s = LabResultAdmin.get_urls()
        # base_dir = os.path.dirname(__file__)
        # pdf_root = os.path.join(base_dir, 'upload-pdf/')
        pdf_file = LabResult.objects.last()
        # file_path = pdf_file.file.path
        df = read_pdf(pdf_file, pages="all", encoding="cp1252")
        result = df[1].to_json(orient="records")
        return JsonResponse({"result": result})
        # pdf_path = request.POST.get('pdfPath')


class LabResultView(viewsets.ModelViewSet):
    # @api_view(['POST'])
    # def process_pdf(request):
    #     # pdf_path = 'upload-pdf/cbc3.pdf'
    #     pdf_path = request.POST.get('pdfPath')
    #     df = read_pdf(pdf_path, pages='all', encoding='cp1252')
    #     result = df[1].to_json(orient='records')
    #     return JsonResponse({'result':result})

    @api_view(["GET"])
    def fetch_pdf(request):
        try:
            queryset = LabResult.objects.all()
            serializer = LabResultSerializer(queryset, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response(
                {"message": "Failed to fetch pdfs.", "error": str(e)},
                status=status.HTTP_400_BAD_REQUEST,
            )

    @api_view(["GET"])
    def fetch_pdf_by_id(request, pdfId):
        try:
            queryset = LabResult.objects.filter(pk=pdfId)
            serializer = LabResultSerializer(queryset, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response(
                {"message": "Failed to fetch pdf.", "error": str(e)},
                status=status.HTTP_400_BAD_REQUEST,
            )

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

    # #tabnula
    # def select_pdf(request):
    #     if request.method == 'POST':
    #         selected_pdfs = request.POST.getlist('item')
    #         pdf_contents = []

    #         for pdf_id in selected_pdfs:
    #             pdf = LabResult.objects.get(pdfId=pdf_id)
    #             tables = read_pdf(pdf.pdf.path, pages='all', output_format='json')

    #             table = tables[1]

    #             # table_json = table.to_json()

    #             jsonLabResult = JsonLabResult(jsonData=table)
    #             jsonLabResult.save()
    #             print(table)
    #             pdf_contents.append(table)
    #             json_data = json.dumps(pdf_contents)
    #         return JsonResponse({'result': json.loads(json_data)})
