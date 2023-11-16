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
import re
import datetime
from PyPDF2 import PdfReader
from rest_framework.views import APIView
from django.shortcuts import render,  redirect
from api.modules.laboratory.form import PdfImportLabResultForm
from django import forms
from django.contrib import admin, messages
from django.http import HttpResponseRedirect
import json
from django.urls import reverse


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
        labels = { 
            # "investigation": "Investigation",
            "pdf": "PDF File",
            "patient": "Select Patient",
        }
        widgets = { 
            # "comment": forms.Textarea(attrs={"id": "id_comment"}),
            "pdf": forms.ClearableFileInput(attrs={"id": "lab_result_file"}),
            "patient": forms.Select(attrs={"id": "select_patient"}),
        }


class ProcessPdf(APIView):
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

    def select_pdf(request, patient):
        if request.method == "POST":
            selected_pdfs = request.POST.getlist("item")
            pdf_contents = []
            tableAppend = []
            tempList = []
            uniqueDataList = []
            newLista = []
            labresultTitles = []

            for pdf_id in selected_pdfs:
                pdf_instance = LabResult.objects.get(pdfId=pdf_id) 
                patient_id = pdf_instance.patient 
                pdf_title = pdf_instance.title
                str_collected_on = None
                str_investigation = None 
                
                tables = read_pdf(
                    pdf_instance.pdf.path, pages="all", output_format="json"
                )
                
                reader = PdfReader(pdf_instance.pdf.path) 

                for page in reader.pages:
                    text = page.extract_text()
                    if text:
                        firstWord = text.split()[0]
                        labresultTitles.append(firstWord)

                for index, j in enumerate(tables):
                    readTable = tables[index]
                    tableAppend = [tableAppend, readTable]

                cleaned_data = cleanJsonTable(tableAppend)

                print(cleaned_data)

                def get_data_and_move_higher(arr):
                    for item in arr:
                        if isinstance(item, dict) and "data" in item:
                            data_contents = item["data"]
                            extract_list = {"data": data_contents}
                            tempList.append(extract_list)

                        if isinstance(item, list):
                            get_data_and_move_higher(item)

                get_data_and_move_higher(cleaned_data)

                print(get_data_and_move_higher)

                for item in tempList:
                    data_contents = item["data"]
                    if data_contents not in uniqueDataList:
                        uniqueDataList.append(data_contents)

                result_list = [
                    {"data": data_contents} for data_contents in uniqueDataList
                ]
                for item in result_list:
                    newLista.append(item)

                for item in newLista:
                    for text_data in item["data"][3]:
                        if text_data["text"] == "Collected on:":
                            str_collected_on = item["data"][3][1]["text"]
                            break
                    for text_data in item["data"][4]:
                        if text_data["text"] == "Investigations:":
                            str_investigation = item["data"][4][1]["text"]
                            break

 
                investigations = str_investigation
                collected_on = datetime.datetime.strptime(
                    str_collected_on, "%d/%m/%Y"
                ).strftime("%Y-%m-%d") 

                jsonLabResult = JsonLabResult(
                    jsonTables=newLista,
                    labresultTitles=labresultTitles,
                    collectedOn=collected_on,
                    title=pdf_title,
                    labresult=pdf_instance, 
                    investigation=investigations,
                    patient=patient_id,
                )
                jsonLabResult.save()
                pdf_contents.append(newLista)
                json_data = json.dumps(pdf_contents)
                messages.success(request, 'Scanned Laboratory Result Successfully!')
                messages.info(request, 'Check results on the SAMS application.')
            return HttpResponseRedirect("../../../admin")
        else: 
            pdf_list = LabResult.objects.select_related('patient').filter(patient_id=patient)
            return render(
                request, "laboratory/select/pdf_select.html", {"pdf_list": pdf_list}
            ) 
        
    def all_select_pdf(request):  
        if request.method == "POST":  
            selected_pdfs = request.POST.getlist("item")
            pdf_contents = []
            tableAppend = []
            tempList = []
            uniqueDataList = []
            newLista = []
            labresultTitles = []

            for pdf_id in selected_pdfs:
                pdf_instance = LabResult.objects.get(pdfId=pdf_id) 
                patient_id = pdf_instance.patient 
                pdf_title = pdf_instance.title  
                str_collected_on = None
                str_investigation = None
                
                tables = read_pdf(
                    pdf_instance.pdf.path, pages="all", output_format="json"
                )
                reader = PdfReader(pdf_instance.pdf.path) 

                for page in reader.pages:
                    text = page.extract_text()
                    if text:
                        firstWord = text.split()[0]
                        labresultTitles.append(firstWord)

                for index, j in enumerate(tables):
                    readTable = tables[index]
                    tableAppend = [tableAppend, readTable]

                cleaned_data = cleanJsonTable(tableAppend)

                def get_data_and_move_higher(arr):
                    for item in arr:
                        if isinstance(item, dict) and "data" in item:
                            data_contents = item["data"]
                            extract_list = {"data": data_contents}
                            tempList.append(extract_list)

                        if isinstance(item, list):
                            get_data_and_move_higher(item)

                get_data_and_move_higher(cleaned_data)

                for item in tempList:
                    data_contents = item["data"]
                    if data_contents not in uniqueDataList:
                        uniqueDataList.append(data_contents)

                result_list = [
                    {"data": data_contents} for data_contents in uniqueDataList
                ]
                for item in result_list:
                    newLista.append(item)

                for item in newLista:
                    for text_data in item["data"][3]:
                        if text_data["text"] == "Collected on:":
                            str_collected_on = item["data"][3][1]["text"]
                            break
                    for text_data in item["data"][4]:
                        if text_data["text"] == "Investigations:":
                            str_investigation = item["data"][4][1]["text"]
                            break

                collected_on = datetime.datetime.strptime(
                    str_collected_on, "%d/%m/%Y"
                ).strftime("%Y-%m-%d") 

                jsonLabResult = JsonLabResult(
                    jsonTables=newLista,
                    labresultTitles=labresultTitles,
                    collectedOn=collected_on,
                    labresult=pdf_instance,
                    title=pdf_title,
                    investigation=str_investigation,
                    patient=patient_id,
                )
                jsonLabResult.save()
                pdf_contents.append(newLista)
                json_data = json.dumps(pdf_contents)
                messages.success(request, 'Scanned Laboratory Result Successfully!')
                messages.info(request, 'Check results on the SAMS application.')
            return HttpResponseRedirect("../../admin") 
        else: 
            pdf_list = LabResult.objects.all() 
            return render(
                request, "laboratory/select/pdf_all_select.html", {"pdf_list": pdf_list}
            )
        
    def delete_pdf(request, pdfId):
        try:
            pdf = LabResult.objects.get(pdfId=pdfId)
            pdf.delete()
            return JsonResponse({'success': True})
        except LabResult.DoesNotExist:
            return JsonResponse({'success': False, 'error': 'PDF not found'})
         
    def upload_pdf(request):
        if request.method == "POST":
            form = LabResultForm(request.POST, request.FILES)
            if form.is_valid():
                form.save()
                saveForm = form.save(commit=False)
                patientID = saveForm.patient.patientID  
                
            return HttpResponseRedirect(
                reverse("select_pdf", kwargs={"patient": patientID})
            )

        else:
            form = LabResultForm()
            return render(request, "laboratory/upload/pdf_upload.html", {"form": form})
 
 
    @api_view(["POST"])
    def post(request): 
        pdf_file = LabResult.objects.last() 
        df = read_pdf(pdf_file, pages="all", encoding="cp1252")
        result = df[1].to_json(orient="records")
        return JsonResponse({"result": result}) 


class LabResultView(viewsets.ModelViewSet): 

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
 