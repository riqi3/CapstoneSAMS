from django.db import models
from django.contrib.auth.models import  AbstractBaseUser, BaseUserManager, PermissionsMixin 
import os
import datetime
from django import forms
# Create your models here.
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
        return self.create_user(username, password, **extra_fields)
    
class Account(AbstractBaseUser, PermissionsMixin):
    ACCOUNT_ROLE_CHOICES = [
        ('physician', 'Physician'),
        ('medtech', 'MedTech'),
        ('nurse', 'Nurse'),
        ('admin', 'Admin'),
    ]
    accountID = models.CharField(max_length=100, primary_key=True)
    username = models.CharField(max_length=100, unique=True)
    password = models.CharField(max_length=100, blank = False)
    firstName = models.CharField(max_length=100, blank = False)
    middleName = models.CharField(max_length=100, blank = False)
    lastName = models.CharField(max_length=100, blank = False)
    accountRole = models.CharField(max_length=100, choices=ACCOUNT_ROLE_CHOICES)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['accountID','accountRole']

    objects = AccountManager()

    class Meta:
        db_table = "account"
    
    @property
    def is_anonymous(self):
        return False
    
    @property
    def is_authenticated(self):
        return True
    


# def filepath(request, filename):
#     old_filename  =filename
#     timeNow = datetime.datetime.now().strftime('%Y%m%d%H:%M:%S')
#     filename = '%%' % (timeNow, old_filename)
#     return os.path.join('uploads/', filename)

# class LabResult(models.Model):
#     name = models.TextField(max_length=128)
#     comment = models.TextField(max_length=512)
#     pdf = models.

# class UploadFileForm(forms.Form):
#     name = forms.CharField(max_length=50)
#     comments = forms.TimeField()
#     file = forms.FileField(upload_to=filepath, null=True, blank=True)

class LabResult(models.Model):
    title = models.CharField(max_length=128)
    comment = models.TextField(max_length=512)
    pdf = models.FileField(upload_to='upload/')
 
    class Meta:
        ordering = ['title']
     
    def __str__(self):
        return f"{self.title}"

class UploadLabResult(forms.ModelForm):
    class Meta:
        model = LabResult
        fields = ('title', 'comment','pdf')

class pdfJson(models.Model):
    text = models.TextField()

class Patient(models.Model):

    GENDER_OPTIONS = {
        ('M', 'Male'),
        ('F', 'Female')
    }

    #Patient Indentification
    patientID = models.CharField(max_length=100, primary_key=True)
    firstName = models.CharField(max_length=100, blank = False)
    middleName = models.CharField(max_length=100, blank = False)
    lastName = models.CharField(max_length=100, blank = False)
    gender = models.CharField(choices = GENDER_OPTIONS)
    birthDate = models.DateField(blank = False)
    phone = models.CharField(max_length = 20, blank = True)
    email = models.CharField(max_length = 50, blank = True)

class Data_Logs(models.Model):
    #Log Attributes
    logNum = models.AutoField(primary_key = True) #Auto incrementing field
    event = models.CharField(max_length = 500)
    date = models.DateTimeField()
    account = models.ForeignKey(Account, on_delete=models.CASCADE)

class Health_Record(models.Model):
    #Health Record Attributes
    recordNum = models.CharField(primary_key = True)
    patient = models.ForeignKey(Patient, on_delete = models.CASCADE)

class Comment(models.Model):
    #Comment Attributes
    comNum = models.AutoField(primary_key = True)
    content = models.CharField(max_length = 3000)
    account = models.ForeignKey(Account, on_delete = models.CASCADE)
    health_record = models.ForeignKey(Health_Record, on_delete = models.CASCADE)

class Prescription(models.Model):
    #Prescription Attributes
    presNum = models.AutoField(primary_key = True)
    dosage = models.PositiveIntegerField(blank = False)
    timeFrame = models.DateTimeField(blank = False)
    amount = models.PositiveIntegerField(blank = False)
    account = models.ForeignKey(Account, on_delete = models.CASCADE)
    health_record = models.ForeignKey(Health_Record, on_delete = models.CASCADE)

class Medicine(models.Model):
    #Medicine Attributes
    drugId = models.CharField(primary_key = True)
    drugCode = models.CharField(blank = False)
    drugName = models.CharField(blank = False)

class Personal_Notes(models.Model):
    noteNum = models.AutoField(primary_key = True)
    title = models.CharField(max_length = 20)
    content = models.CharField(max_length = 3000)
    account = models.ForeignKey(Account, on_delete = models.CASCADE)

class Symptoms(models.Model):
    sympNum = models.AutoField(primary_key = True)
    symptom = models.CharField(max_length = 3000)

class Medical_History(models.Model):
    histNum = models.AutoField(primary_key = True)
    health_record = models.ForeignKey(Health_Record, on_delete = models.CASCADE)

class Patient_Symptoms(models.Model):
    sympID = models.AutoField(primary_key = True)
    medical_history = models.ForeignKey(Medical_History, on_delete = models.CASCADE)
        