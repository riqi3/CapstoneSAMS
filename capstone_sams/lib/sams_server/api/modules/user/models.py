import uuid 
from django.db import models
from django.utils import timezone
from django.contrib.auth.models import  AbstractBaseUser, BaseUserManager, PermissionsMixin 
from rest_framework_simplejwt.tokens import RefreshToken
import os

'''
This model manages custom user models which in this case is
the Account model.
'''
class AccountManager(BaseUserManager):
    def create_user(self, username, password=None, **extra_fields):
        if not username:
            raise ValueError('The Username field must be set')
        user = self.model(username=username, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, username, password, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('accountRole', 'admin')
        return self.create_user(username, password, **extra_fields)
    
 

'''
This model represent the user accounts
inputted and stored into the system. 
Each account is assigned a role. This role is 
stored in a variable called accountRole. This
is used for restricting certain functions from 
certain users.
Each account also has a token that will be use for
security purposes.
'''
class Account(AbstractBaseUser, PermissionsMixin):

    ACCOUNT_ROLE_CHOICES = [
        ('physician', 'Physician'),
        ('nurse', 'Nurse'),
        ('working student', 'Working Student'),
        ('admin', 'Admin'),
    ]

    #Account Attributes
    accountID = models.AutoField(primary_key = True)
    profile_photo = models.ImageField(blank = True, default=None,upload_to ='upload-photo/' ) 
    username = models.CharField(max_length=100, unique=True)
    password = models.CharField(max_length=100, blank = False)
    firstName = models.CharField(max_length=100, blank = False) 
    middleName = models.CharField(max_length=100, blank = False)
    lastName = models.CharField(max_length=100, blank = False)
    # suffixTitle = models.CharField(max_length=10, blank = False)
    accountRole = models.CharField(max_length=100, choices=ACCOUNT_ROLE_CHOICES, blank=True)
    token = models.CharField(max_length=255, blank=True, null=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    isDeleted = models.BooleanField(default = False)

    USERNAME_FIELD = 'username'
    # REQUIRED_FIELDS = ['accountID','accountRole']

    objects = AccountManager()
 

    class Meta:
        db_table = "account"
        verbose_name = "Account Record"
        verbose_name_plural = "Account Record"
    
    @property
    def is_anonymous(self):
        return False
    
    @property
    def is_authenticated(self):
        return True
    
    def generate_token(self):
        refresh = RefreshToken.for_user(self)
        self.token = str(refresh.access_token)
        self.save()
        return self.token
'''
This model represent the notes that
each user has inputted and stored into the system.
Only the user that has inputted will have access to their
own note.
Each note is only inputted and owned by one user account.
'''
class Personal_Note(models.Model):
    #Personal Note Attributes
    noteNum = models.CharField(max_length=100, primary_key = True)
    title = models.CharField(max_length = 20)
    content = models.CharField(max_length = 3000)
    account = models.ForeignKey(Account, on_delete = models.CASCADE)
    user = models.CharField(null=True)
    isDone = models.BooleanField(default=False)
    isDeleted = models.BooleanField(default = False)
    
'''
This model represent the logs that are automatically generated by user actions
and then stored into the system.
Only accounts with admin user roles are allowed to see these logs.
To know who generated the log, a log is connected to only one user account.
'''
class Data_Log(models.Model):
    #Log Attributes
    logNum = models.AutoField(primary_key = True)
    event = models.CharField(max_length = 500)
    date = models.DateTimeField(default=timezone.now, blank=True)
    type = models.CharField(max_length = 1000, blank = True)
    account = models.ForeignKey(Account, on_delete=models.CASCADE)
    isDeleted = models.BooleanField(default = False)

    class Meta:
        verbose_name = "Data Logs"
        verbose_name_plural = "Data Logs"