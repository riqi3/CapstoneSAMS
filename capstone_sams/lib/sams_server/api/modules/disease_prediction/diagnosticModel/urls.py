from django.urls import path
from . import views

urlpatterns = [
    path('create_diagnostic_record/', views.create_diagnostic_record, name='create_symptom_record'),
    path('train-model/', views.TrainModelView.as_view(), name='train-model'),
]