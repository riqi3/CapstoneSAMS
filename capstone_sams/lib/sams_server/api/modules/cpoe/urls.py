from .views import CommentView, MedicineView
from django.urls import path

urlpatterns = [
    path('api/comments/create/<str:accountId>/<str:recordNum>/', CommentView.create_comment, name='create_comment'),
    path('api/comments/get/', CommentView.fetch_comments, name='fetch_comments'),
    path('api/comments/get/<str:accountId>', CommentView.fetch_comments_by_account_id, name='fetch_comments_by_account_id'),
    path('api/comments/update/<int:comNum>', CommentView.update_comment, name='update_comment'),
    path('api/comments/delete/<int:comNum>', CommentView.delete_comment, name='delete_comment'),
    path('api/medicines/', MedicineView.fetch_medicine, name='fetch_medicines'),
    path('api/medicines/<str:drugID>', MedicineView.fetch_medicine_by_id, name='fetch_medicine'),
    path('api/medicines/<str:presNum>', MedicineView.fetch_medicine_through_prescription, name='fetch_medicine_through_prescription'),
]
