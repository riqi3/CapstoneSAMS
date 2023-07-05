from django.shortcuts import render
from tabula.io import read_pdf
import pandas as pd
from django.http import JsonResponse
   
def process_pdf(request):
    # file_path = "\Users\nulltest\ocr\cbc.pdf"
    df = read_pdf(file_path, pages='all', encoding='cp1252')
    df = df[2].to_json(orient='records')
    return JsonResponse(df, safe=False)