from .views import PatientView, HealthRecordView,ContactPersonView
from django.urls import path

urlpatterns = [
    path('patients/create/', PatientView.create_patient, name='create_patient'), #API Endpoint for patient creation
    path('patients/', PatientView.fetch_patients, name='fetch_patients'), #API Endpoint for patient retrieval
    path('patients/<str:patientID>', PatientView.fetch_patient_by_id, name='fetch_patient'), #API Endpoint for patient retrieval based on patient id
    path('patients/update/', PatientView.update_patient, name='update_patients'), #API Endpoint for patient data update
    path('patients/history/<str:patientID>', HealthRecordView.fetch_record_by_id, name='patient_record'), #API Endpoint for health record retrieval
    path('patients/history/update/<str:patientID>', HealthRecordView.update_health_record, name='update_patient_record'),
    path('patients/contact/<str:patientID>', HealthRecordView.fetch_contact_by_id, name='fetch_contact_by_id'),
    path('patients/contact/update/<str:patientID>', ContactPersonView.update_contact_person, name='update_contact_person')
]
