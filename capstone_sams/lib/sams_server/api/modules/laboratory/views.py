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
from django.shortcuts import render
from api.modules.laboratory.form import PdfImportLabResultForm
from django import forms
from django.contrib import admin, messages
from django.http import HttpResponseRedirect
import json
from django.urls import reverse

# def get_data_and_move_higher(arr):


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
            "title": "Title for Laboratory Result",
            "comment": "Comments",
            "pdf": "PDF File",
            "patient": "Select Patient",
        }
        widgets = {
            "title": forms.TextInput(attrs={"id": "id_title"}),
            "comment": forms.Textarea(attrs={"id": "id_comment"}),
            "pdf": forms.ClearableFileInput(attrs={"id": "lab_result_file"}),
            "patient": forms.Select(attrs={"id": "select_patient"}),
        }
        # widgets = {
        #     "title": forms.TextInput(attrs={"id": "id_title"}),
        #     "comment": forms.Textarea(attrs={"id": "lab_comment"}),
        #     "pdf": forms.ClearableFileInput(attrs={"id": "lab_result_file"}),
        #     "patient": forms.Select(attrs={"id": "select_patient"}),
        # }


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
                pdf_title = pdf_instance.title
                pdf_comment = pdf_instance.comment
                patient_id = pdf_instance.patient
                str_collected_on = None
                # test = pdf_instance.patient
                # patient_instance = Patient.objects.filter(patient=test)
                # patient_id = patient_instance.patientID
                # pdf_title= str(request.POST.get('title'))

                tables = read_pdf(
                    pdf_instance.pdf.path, pages="all", output_format="json"
                )
                reader = PdfReader(pdf_instance.pdf.path)

                """tables[index] retrieves the table according by index.
                in this case the format of the labresult has the following
                tables: 1.) tables[0] contains the personal information. 
                2.) tables[1] contains the haematology of the blood
                3.) tables[3] contains the biochemistry. theese tables are 
                then stored in their respective rows
                """

                for page in reader.pages:
                    text = page.extract_text()
                    # first_word = text.split()[0] if text else None
                    # print(first_word)
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

                # print('aaaaaaaaaaa', tempList)
                # print('\n\n')

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

                # print('bbbbbbbbb', newLista)
                print(str_collected_on)

                # h = json.dumps(collected_on)
                # matches = re.findall(r'(\d+/\d+/\d+)',h)
                # print(matches)
                # print(h)
                # collected_on = datetime.datetime.strptime(str_collected_on, '%d/%m/%Y').strftime('%B %d, %Y')
                collected_on = datetime.datetime.strptime(
                    str_collected_on, "%d/%m/%Y"
                ).strftime("%Y-%m-%d")
                print("aaa ", collected_on)

                jsonLabResult = JsonLabResult(
                    jsonTables=newLista,
                    labresultTitles=labresultTitles,
                    collectedOn=collected_on,
                    labresult=pdf_instance,
                    title=pdf_title,
                    comment=pdf_comment,
                    patient=patient_id,
                )
                jsonLabResult.save()
                # print(jsonLabResult)

                pdf_contents.append(jsonLabResult)
                json_data = json.dumps(pdf_contents)
            # return JsonResponse({"result": json.loads(json_data)})
            return HttpResponseRedirect(reverse("admin"))
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
                a = form.save(commit=False)
                patientID = a.patient.patientID
            return HttpResponseRedirect(
                reverse("select_pdf", kwargs={"patient": patientID})
            )

        else:
            form = LabResultForm()
            return render(request, "laboratory/upload/pdf_upload.html", {"form": form})

    # def upload_pdf(self, request):
    #     if request.method == "POST":
    #         pdf_file = request.FILES["pdf_upload"]
    #         if not pdf_file.name.endswith(".pdf"):
    #             messages.warning(request, "The wrong file type was uploaded")
    #             return HttpResponseRedirect(request.path_info)

    #     form = PdfImportLabResultForm()
    #     data = {"form": form}
    #     return render(request, "admin/pdf_upload.html", data)

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
