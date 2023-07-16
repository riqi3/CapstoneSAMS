from .views import PersonalNotesView
from django.urls import path

urlpatterns = [
    path('api/notes/get/<str:accountID>', PersonalNotesView.fetch_personal_notes, name='fetch_personal_notes'),
    path('api/notes/create/', PersonalNotesView.create_personal_note, name='create_personal_note'),
    path('api/notes/update/<int:noteNum>', PersonalNotesView.update_personal_note, name='update_personal_note'),
    path('api/notes/delete/<int:noteNum>', PersonalNotesView.delete_personal_note, name='delete_personal_note'),
]
