from .views import LabResultView, ProcessPdf
from django.urls import path
from .ocr import view_function  

urlpatterns = [
    path('labresult/', LabResultView.fetch_pdf, name='fetch_pdf'),
    path('labresult/<str:pdfId>/', LabResultView.fetch_pdf_by_id, name='fetch_pdf_by_id'),
    path('upload/',  ProcessPdf.upload_pdf1, name='upload_pdf1'),
    path('delete_pdf/<int:pdfId>/', ProcessPdf.delete_pdf, name='delete_pdf'),
    path('select/',  ProcessPdf.all_select_pdf, name='all_select_pdf'),
    path('select/<str:patient>/',  ProcessPdf.select_pdf, name='select_pdf'),
    path('select/scan/<str:jsonId>/', ProcessPdf.fetch_json_pdf_by_id, name='fetch_json_pdf_by_id'),
    path('select/scan/labresult/',  ProcessPdf.fetch_json_pdf, name='fetch_json_pdf'),
    path('select/scan/labresult/<str:patient>/', ProcessPdf.fetch_patient_labresult_by_id, name='fetch_patient_labresult_by_id'),
]
