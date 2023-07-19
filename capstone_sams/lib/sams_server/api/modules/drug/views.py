# from django.shortcuts import render 
# from api.modules.drug.models import UploadDrugFile
# from rest_framework.decorators import api_view
# from rest_framework import viewsets
# import csv

# def decode_utf8(line_iterator):
#     for line in line_iterator:
#         yield line.decode("utf-8")

# class CSVUploadView(viewsets.ModelViewset):
#     @api_view(['POST'])

#     def UploadCSVView(request):
#         if request.method == "GET":
#         form = UploadDrugFile()
#         return render(request, "addDrug.html", {"form": form})
#         form = UploadDrugFile(request.POST, request.FILES)
#         if form.is_valid():
#             drugs_file = csv.reader(decode_utf8(request.FILES["sent_file"]))
#             next(drugs_file)

