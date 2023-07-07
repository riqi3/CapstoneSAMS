from django.shortcuts import render,redirect
from tabula.io import read_pdf
from django.contrib import messages
import pandas as pd
from django.http import JsonResponse

from .models import UploadLabResult, UploadLabResult
# from somewhere import handle_uploaded_file
from django.http import HttpResponseRedirect, HttpResponse
   
# def process_pdf(request):
#     # file_path = "\Users\nulltest\ocr\cbc.pdf"
#     df = read_pdf(file_path, pages='all', encoding='cp1252')
#     df = df[2].to_json(orient='records')
#     return JsonResponse(df, safe=False)

# def laboratories(request):
#     if request.method == 'POST':
#          pdf = UploadFileForm()
#          pdf.name = request.POST.get('lab-result-title')
#          pdf.comments = request.POST.get('lab-results-comments')
#          if len(request.FILES) !=0:
#              pdf.file = request.FILES['lab-result-file']
#          pdf.save()
#          messages.success(request, 'File added successfully!')
#          return redirect('/')
#     return render(request, 'ocr.html')

# def handle_uploaded_file(f):
#     with open('C:\Users\nulltest\ocr\upload', 'wb+') as destination:
#         for chunk in f.chunks():
#             destination.write(chunk)

# def upload_pdf(request):
#     if request.method == 'POST':
#         form = UploadFileForm(request.POST, request.FILES)
#         if form.is_valid():
#             handle_uploaded_file(request.FILES['file'])
#             return HttpResponseRedirect('/success/url/')
#     else:
#         form = UploadFileForm()
#     return render(request, 'upload.html', {'form': form})

def ViewLabResult(request):
    if request.method == 'POST':
        form = UploadLabResult(request.POST,request.FILES)
        if form.is_valid():
            form.save()
            return HttpResponse('The file is saved')
    else:
        form = UploadLabResult()
    return render(request, 'ocr.html', {'form':form})

def process_pdf(request):
    pdf_path = "cbc.pdf"
    dfs = read_pdf(pdf_path, pages='all', encoding='cp1252', pandas_options={'header':True})
    json_data = dfs[1].to_json(orient='columns')
    print(json_data)
    dfs[0].to_json('output.json', orient='columns')
