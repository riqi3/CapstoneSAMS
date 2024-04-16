from django.urls import path
from . import views

urlpatterns = [
    path('create_diagnostic_record/', views.create_diagnostic_record, name='create_diagnostic_record'),
    path('train-model/', views.TrainModelView.as_view(), name='train-model'),
    path('delete_diagnostic_record/<int:record_id>/', views.delete_diagnostic_record, name='delete_diagnostic_record'),
    path('get_latest_record_id/', views.get_latest_record_id, name='get_latest_record_id'),
    path('update_disease/<int:record_id>/', views.update_disease, name='update_disease'),
    path('update_outcome/<int:record_id>/', views.update_outcome, name='update_outcome'),
]