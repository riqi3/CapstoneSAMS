from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
from django.contrib import admin
from django.urls import path, include
from api.views import drug_detail, process_pdf, ViewUploadPDF, ViewUploadCSV, PatientView, MedicineView, HealthRecordView, SymptomsView, PersonalNotesView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
 
    path('api/ocr/', ViewUploadPDF, name='ViewUploadPDF'),
    path('api/addDrug/', ViewUploadCSV, name='ViewUploadCSV'),
    path('api/drugDetail/<int:pk>/', drug_detail, name='drug_detail'),
    path('api/patients/create/', PatientView.create_patient, name='create_patient'),
    path('api/patients/get/', PatientView.fetch_patients, name='fetch_patients'),
    path('api/patients/get/<str:patientID>', PatientView.fetch_patient_by_id, name='fetch_patient'),
    path('api/patients/update/', PatientView.update_patient, name='update_patients'),
    path('api/medicines/get/', MedicineView.fetch_medicine, name='fetch_medicines'),
    path('api/medicines/get/<str:drugID>', MedicineView.fetch_medicine_by_id, name='fetch_medicine'),
    path('api/records/get/', HealthRecordView.fetch_records, name='fetch_records'),
    path('api/records/get/<str:recordNum>', HealthRecordView.fetch_record_by_num, name='fetch_record'),
    path('api/symptoms/get/', SymptomsView.fetch_symptoms, name='fetch_symptoms'),
    path('api/symptoms/get/<str:sympNum>', SymptomsView.fetch_symptoms_by_num, name='fetch_symptom'),
    path('api/notes/get/<str:accountID>', PersonalNotesView.fetch_personal_notes, name='fetch_personal_notes'),
    path('api/notes/create/', PersonalNotesView.create_personal_note, name='create_personal_note'),
    path('api/notes/update/<int:noteNum>', PersonalNotesView.update_personal_note, name='update_personal_note'),
    path('api/notes/delete/<int:noteNum>', PersonalNotesView.delete_personal_note, name='delete_personal_note'),
    # path('predict/', predict),
]
