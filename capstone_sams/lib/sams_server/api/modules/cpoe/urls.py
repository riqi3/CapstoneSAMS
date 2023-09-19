from .views import CommentView, MedicineView, PrescriptionView
from django.urls import path

urlpatterns = [
    path('comments/create/<str:accountId>/<str:recordNum>/', CommentView.create_comment, name='create_comment'),
    path('comments/get/', CommentView.fetch_comments, name='fetch_comments'),
    path('comments/get/<str:accountId>', CommentView.fetch_comments_by_account_id, name='fetch_comments_by_account_id'),
    path('comments/update/<int:comNum>', CommentView.update_comment, name='update_comment'),
    path('comments/delete/<int:comNum>', CommentView.delete_comment, name='delete_comment'),
    path('medicines/', MedicineView.fetch_medicine, name='fetch_medicines'),
    path('medicines/<str:drugID>', MedicineView.fetch_medicine_by_id, name='fetch_medicine'),
    path('medicines/<str:presNum>', MedicineView.fetch_medicine_through_prescription, name='fetch_medicine_through_prescription'),
    path('prescription/save/', PrescriptionView.save_prescription, name='save_prescription'),
    path('prescription/get/<str:recordNum>', PrescriptionView.fetch_prescription_by_ids, name='fetch_prescription')
]
