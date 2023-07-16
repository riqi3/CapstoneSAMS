from .views import PatientView, SymptomsView
from django.urls import path

urlpatterns = [
    path('patients/create/', PatientView.create_patient, name='create_patient'),
    path('patients/', PatientView.fetch_patients, name='fetch_patients'),
    path('patients/<str:patientID>', PatientView.fetch_patient_by_id, name='fetch_patient'),
    path('patients/update/', PatientView.update_patient, name='update_patients'),
    path('symptoms/', SymptomsView.fetch_symptoms, name='fetch_symptoms'),
    path('symptoms/<str:sympNum>', SymptomsView.fetch_symptoms_by_num, name='fetch_symptom'),
]
