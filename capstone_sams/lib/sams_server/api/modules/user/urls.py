from .views import PersonalNotesView
from django.urls import path

urlpatterns = [
    path('notes/get/<str:accountID>', PersonalNotesView.fetch_personal_notes, name='fetch_personal_notes'),
    path('notes/create/', PersonalNotesView.create_personal_note, name='create_personal_note'),
    path('notes/update/<int:noteNum>', PersonalNotesView.update_personal_note, name='update_personal_note'),
    path('notes/delete/<int:noteNum>', PersonalNotesView.delete_personal_note, name='delete_personal_note'),
]
