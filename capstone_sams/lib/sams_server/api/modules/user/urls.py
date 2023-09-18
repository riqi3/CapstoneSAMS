from .views import PersonalNotesView, ObtainTokenView, LogInView
from django.urls import path

urlpatterns = [
    # path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    # path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('token/', ObtainTokenView.get_token, name='get_token'), #API Endpoint for token creation
    path('login/', LogInView.login, name='login'), #API Endpoint for user login
    path('notes/get/<str:accountID>', PersonalNotesView.fetch_personal_notes, name='fetch_personal_notes'), #API Endpoint for note retrieval
    path('notes/create/', PersonalNotesView.create_personal_note, name='create_personal_note'), #API Endpoint for note creation
    path('notes/update/<str:noteNum>', PersonalNotesView.update_personal_note, name='update_personal_note'), #API Endpoint for note update
    path('notes/done/<str:noteNum>', PersonalNotesView.set_done, name='done_personal_note'), #API Endpoint for setting a note as done or not
    path('notes/delete/<str:noteNum>', PersonalNotesView.delete_personal_note, name='delete_personal_note'), #API Endpoint for note deletion
]
