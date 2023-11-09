from django.shortcuts import render
from tabula.io import read_pdf
import pandas as pd
from django.http import JsonResponse
from django.http import HttpResponse
 
def process_pdf(request):
    pdf_path = 'upload-pdf/'
    df = read_pdf(pdf_path, pages='all', encoding='cp1252')
    df = df[1].to_json(orient='records')
    return JsonResponse(df)

def view_function(request):
    function_code = """
def process_pdf(request):
    pdf_path = 'upload-pdf/'
    df = read_pdf(pdf_path, pages='all', encoding='cp1252')
    df = df[1].to_json(orient='records')
    return JsonResponse(df)
"""
    return HttpResponse(function_code, content_type='text/plain')
