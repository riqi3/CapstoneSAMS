from django.contrib.auth.backends import BaseBackend
from .models import Account

class AccountBackend(BaseBackend):
    def authenticate(self, request, username=None, password=None, **kwargs):
        try:
            account = Account.objects.get(username=username)
        except Account.DoesNotExist:
            return None

        if account.check_password(password):
            return account
        else:
            return None

    def get_user(self, user_id):
        try:
            return Account.objects.get(pk=user_id)
        except Account.DoesNotExist:
            return None