from django.urls import path
from . import views

urlpatterns = [
    path('create_symptom_record/', views.create_symptom_record, name='create_symptom_record'),
    path('train-model/', views.TrainModelView.as_view(), name='train-model'),
    path('delete_symptom_record/<int:record_id>/', views.delete_symptom_record, name='delete_symptom_record'),
    path('get_latest_record_id/', views.get_latest_record_id, name='get_latest_record_id'),
    path('update_prognosis/<int:record_id>/', views.update_prognosis, name='update_prognosis'),

]