from django.urls import path
from . import views

urlpatterns = [
    path('cdss-dataset/', views.SymptomViewSet.as_view({'get': 'list'}), name='health-symptom-list'),
    path('cdss-dataset/upload/', views.SymptomViewSet.as_view({'post': 'upload_data'}), name='upload-health-symptoms'),
    path('create_symptom_record/', views.create_symptom_record, name='create_symptom_record'),
]
