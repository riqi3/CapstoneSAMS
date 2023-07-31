from .views import LabResultView, ProcessPdf
from django.urls import path
from .ocr import view_function  
 

urlpatterns = [
    path('labresult/', LabResultView.fetch_pdf, name='fetch_pdf'),
    path('labresult/<str:pdfId>', LabResultView.fetch_pdf_by_id, name='fetch_pdf_by_id'),
    path('upload/',  ProcessPdf.upload_pdf1, name='upload_pdf1'),
    path('select/',  ProcessPdf.select_pdf, name='select_pdf'),
    path('select/scan/',  ProcessPdf.scan_pdf, name='scan_pdf'),
]
