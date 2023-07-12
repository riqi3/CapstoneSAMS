# from rest_framework_simplejwt.views import (
#     TokenObtainPairView,
#     TokenRefreshView,
# )
from django.contrib import admin
from django.urls import path, include
from api.views import  PatientView, MedicineView, SymptomsView, PersonalNotesView, CommentView
# process_pdf, ViewLabResult, predict HealthRecordView,

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    # path('api/ocr/', process_pdf, name='process_pdf'),
    path('api/ocr/', ViewLabResult, name='ViewLabResult'),
    path('api/patients/create/', PatientView.create_patient, name='create_patient'),
    path('api/patients/', PatientView.fetch_patients, name='fetch_patients'),
    path('api/patients/<str:patientID>', PatientView.fetch_patient_by_id, name='fetch_patient'),
    path('api/patients/update/', PatientView.update_patient, name='update_patients'),
    path('api/comments/create/<str:accountId>/<str:recordNum>/', CommentView.create_comment, name='create_comment'),
    path('api/comments/get/', CommentView.fetch_comments, name='fetch_comments'),
    path('api/comments/get/<str:accountId>', CommentView.fetch_comments_by_account_id, name='fetch_comments_by_account_id'),
    path('api/comments/update/<int:comNum>', CommentView.update_comment, name='update_comment'),
    path('api/comments/delete/<int:comNum>', CommentView.delete_comment, name='delete_comment'),
    path('api/medicines/', MedicineView.fetch_medicine, name='fetch_medicines'),
    path('api/medicines/<str:drugID>', MedicineView.fetch_medicine_by_id, name='fetch_medicine'),
    path('api/medicines/<str:presNum>', MedicineView.fetch_medicine_through_prescription, name='fetch_medicine_through_prescription'),
    # path('api/records/', HealthRecordView.fetch_records, name='fetch_records'),
    # path('api/records/<str:recordNum>', HealthRecordView.fetch_record_by_num, name='fetch_record'),
    path('api/symptoms/', SymptomsView.fetch_symptoms, name='fetch_symptoms'),
    path('api/symptoms/<str:sympNum>', SymptomsView.fetch_symptoms_by_num, name='fetch_symptom'),
    path('api/notes/get/<str:accountID>', PersonalNotesView.fetch_personal_notes, name='fetch_personal_notes'),
    path('api/notes/create/', PersonalNotesView.create_personal_note, name='create_personal_note'),
    path('api/notes/update/<int:noteNum>', PersonalNotesView.update_personal_note, name='update_personal_note'),
    path('api/notes/delete/<int:noteNum>', PersonalNotesView.delete_personal_note, name='delete_personal_note'),
    path('predict/', PredictDisease.as_view(), name='predict'),
]
