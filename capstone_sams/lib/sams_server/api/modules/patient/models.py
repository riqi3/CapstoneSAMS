import uuid 
from django.utils import timezone
from django.db import models
from api.modules.user.models import Account
'''
This model represent the patients
inputted and stored into the system.
'''
class Patient(models.Model):

    GENDER_OPTIONS = {
        ('M', 'Male'),
        ('F', 'Female')
    } 
    STATUS_OPTIONS = {
        ('Single', 'Single'),
        ('Married', 'Married'),
        ('Divorced', 'Divorced'),
        ('Separated', 'Separated'),
        ('Widowed', 'Widowed')
    } 
    COURSE_OPTIONS = {
        ('Nursery', 'Nursery'),
        ('Kindergarten', 'Kindergarten'),
        ('Junior High School','Junior High School'),
        ('Senior High School','Senior High School'),
        ('Tertiary','Tertiary'),
        ('Law School','Law School')
    } 

    #Patient Indentification
    patientID = models.UUIDField(primary_key = True, default = uuid.uuid4, 
         editable = False)
    firstName = models.CharField(max_length=100, blank = False)
    middleInitial = models.CharField(max_length=1, blank = False)
    lastName = models.CharField(max_length=100, blank = False)
    age = models.IntegerField(blank= False)
    gender = models.CharField(choices = GENDER_OPTIONS)
    patientStatus = models.CharField(choices = STATUS_OPTIONS)
    birthDate = models.DateField(blank = False)  
    course = models.CharField(max_length=300, blank = False)
    yrLevel = models.IntegerField(blank = False)
    studNumber = models.CharField(max_length=100, blank = False)
    address = models.CharField(blank= False)
    height = models.FloatField(blank = False)
    weight = models.FloatField(blank= False) 
    phone = models.CharField(max_length = 11, null=True,blank = True)
    email = models.CharField(max_length = 50, null=True,blank = True)  
    
    def __str__(self):
        return f"{self.patientID} - {self.firstName} {self.middleInitial} {self.lastName}"
    
    class Meta:
        verbose_name = "Patient Record"
        verbose_name_plural = "Patient Record"

class Contact_Person(models.Model):
    patient = models.ForeignKey(Patient, on_delete = models.CASCADE)
    contactID = models.UUIDField(primary_key = True, default = uuid.uuid4, 
         editable = False)
    fullName = models.CharField(max_length=100, blank = False)
    phone = models.CharField(max_length=11, blank = False)
    address = models.CharField(blank= False)
    

'''
This model represent the health records
inputted and stored into the system. Each
record is connected to only one patient.
'''
class Medical_Record(models.Model):
    #Health Record Attributes
    patient = models.ForeignKey(Patient, on_delete = models.CASCADE)
    recordID = models.UUIDField(primary_key = True, default = uuid.uuid4, 
         editable = False) 
    illnesses = models.JSONField(blank = True, default=None, null=True)
    allergies = models.JSONField(blank = True, default=None, null=True)
    pastDiseases = models.JSONField(blank = True, default=None, null=True)
    familyHistory = models.JSONField(blank = True, default=None, null=True)
    lastMensPeriod = models.CharField(max_length=100, blank = True, default=None)
    

    class Meta:
        verbose_name = "Medical Record"
        verbose_name_plural = "Medical Record"


class Health_Record(models.Model):
    class Meta:
        verbose_name = "Health Record"
        verbose_name_plural = "Health Record"

class Present_Illness(models.Model):
    illnessID = models.UUIDField(primary_key = True, default = uuid.uuid4, 
         editable = False)
    illnessName = models.CharField(max_length=100, blank = False)
    complaint = models.TextField(blank = False, default = None, null = False)
    findings = models.TextField(blank = False, default = None, null = False)
    diagnosis = models.TextField(blank = False, default = None, null = False)
    treatment = models.TextField(blank = False, default = None, null = False)
    created_at = models.DateTimeField(auto_now=True, blank = False, null = False)
    updated_at = models.DateTimeField(auto_now=True, blank = False, null = False)
    patient = models.ForeignKey(Patient, on_delete = models.CASCADE)
    created_by = models.ForeignKey(Account, null=True, on_delete = models.CASCADE)