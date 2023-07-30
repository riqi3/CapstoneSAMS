from .views import LabResultView
from django.urls import path

urlpatterns = [
    path('labresult/', LabResultView.fetch_pdf, name='fetch_pdf'),
    path('labresult/<str:pdfId>', LabResultView.fetch_pdf_by_id, name='fetch_pdf_by_id'),
]
