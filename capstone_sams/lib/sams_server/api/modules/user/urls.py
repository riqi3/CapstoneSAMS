from .views import PersonalNotesView, ObtainTokenView, LogInView, AccountView
from django.urls import path

urlpatterns = [
    # path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    # path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('token/', ObtainTokenView.get_token, name='get_token'),
    path('login/', LogInView.login, name='login'),
    path('account/<str:accountID>', AccountView.fetch_user_by_id, name='fetch_user'),
    path('notes/get/<str:accountID>', PersonalNotesView.fetch_personal_notes, name='fetch_personal_notes'),
    path('notes/create/', PersonalNotesView.create_personal_note, name='create_personal_note'),
    path('notes/update/<str:noteNum>', PersonalNotesView.update_personal_note, name='update_personal_note'),
    path('notes/done/<str:noteNum>', PersonalNotesView.set_done, name='done_personal_note'),
    path('notes/delete/<str:noteNum>', PersonalNotesView.delete_personal_note, name='delete_personal_note'),
]
