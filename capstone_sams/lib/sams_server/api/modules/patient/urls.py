from .views import PatientView, MedicalRecordView,ContactPersonView,PresentIllnessView
from django.urls import path

urlpatterns = [
    path('patients/create/', PatientView.create_patient, name='create_patient'), #API Endpoint for patient creation
    path('patients/', PatientView.fetch_patients, name='fetch_patients'), #API Endpoint for patient retrieval
    path('patients/<str:patientID>', PatientView.fetch_patient_by_id, name='fetch_patient'), #API Endpoint for patient retrieval based on patient id
    # path('patients/user/<int:accountID>', PatientView.fetch_patient_by_accountid, name='fetch_patient_by_accountid'),
    path('patients/update/', PatientView.update_patient, name='update_patients'), #API Endpoint for patient data update
    path('patients/delete/<str:patientID>', PatientView.delete_patient, name='delete_patient'), 
    path('patients/history/<str:patientID>', MedicalRecordView.fetch_record_by_id, name='patient_record'), #API Endpoint for health record retrieval
    path('patients/history/create/', MedicalRecordView.create_health_record, name='create_patient_record'),
    path('patients/history/update/<str:patientID>', MedicalRecordView.update_health_record, name='update_patient_record'),
    path('patients/contact/<str:patientID>', MedicalRecordView.fetch_contact_by_id, name='fetch_contact_by_id'),
    path('patients/contact/create/', ContactPersonView.create_contact_person, name='create_contact_person'),
    path('patients/contact/update/<str:patientID>', ContactPersonView.update_contact_person, name='update_contact_person'),
    path('patients/complaints/create/<str:patientID>/<str:accountID>', PresentIllnessView.create_complaint, name='create_complaint'),
    path('patients/complaints/update/<str:illnessID>/<str:accountID>', PresentIllnessView.update_complaint, name='update_complaint'),
    path('patients/complaints/', PresentIllnessView.fetch_complaints, name='fetch_complaints'),
    path('patients/complaints/illness/<str:patientID>', PresentIllnessView.fetch_complaint_by_id, name='fetch_complaint_by_id'),
    path('patients/complaints/illness/delete/<str:illnessID>', PresentIllnessView.delete_complaint, name='delete_complaint'),
]
