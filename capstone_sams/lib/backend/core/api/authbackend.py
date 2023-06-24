from django.contrib.auth.backends import ModelBackend
from api.models import Account

class AccountBackend(ModelBackend):
    def authenticate(self, request, username = None, password = None, **kwargs):
        try:
            account = Account.objects.get(username=username)
            if account.check_password(password):
                return account
        except Account.DoesNotExist:
            return None