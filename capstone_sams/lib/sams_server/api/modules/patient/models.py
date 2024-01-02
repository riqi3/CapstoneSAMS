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

    #Patient Indentification
    patientID = models.AutoField(primary_key = True)
    firstName = models.CharField(max_length=100, blank = False)
    middleInitial = models.CharField(max_length=1, blank = True)
    lastName = models.CharField(max_length=100, blank = False)
    age = models.IntegerField(blank= False)
    gender = models.CharField(choices = GENDER_OPTIONS)
    birthDate = models.DateField(blank = False)
    department = models.CharField(max_length=100, blank = False)
    course = models.CharField(max_length=100, blank = False)
    yrLevel = models.IntegerField(blank = False)
    studNumber = models.CharField(max_length=100, blank = False)
    address = models.CharField(blank= False)
    height = models.FloatField(blank = False)
    weight = models.FloatField(blank= False)
    # registration = models.DateField(blank=False)
    phone = models.CharField(max_length = 20, blank = True)
    email = models.CharField(max_length = 50, blank = True)
    # user = models.CharField(null = True, blank = True)
    assignedPhysician = models.ForeignKey(Account, on_delete = models.CASCADE)

    
    def __str__(self):
        return f"{self.patientID} - {self.firstName} {self.middleInitial} {self.lastName}"
    
    class Meta:
        verbose_name = "Patient Record"
        verbose_name_plural = "Patient Record"

class Contact_Person(models.Model):
    patient = models.ForeignKey(Patient, on_delete = models.CASCADE)
    contactId = models.AutoField(primary_key = True)
    fullName = models.CharField(max_length=100, blank = False)
    contactNum = models.CharField(max_length=50, blank = False)
    contactAddress = models.CharField(blank= False)
    

'''
This model represent the health records
inputted and stored into the system. Each
record is connected to only one patient.
'''
class Health_Record(models.Model):
    #Health Record Attributes
    patient = models.ForeignKey(Patient, on_delete = models.CASCADE)
    recordNum = models.AutoField(primary_key = True)
    symptoms = models.JSONField(blank = True, default=None, null=True)
    diseases = models.JSONField(blank = True, default=None, null=True)
    illnesses = models.JSONField(blank = True, default=None, null=True)
    allergies = models.JSONField(blank = True, default=None, null=True)
    pastDisease = models.JSONField(blank = True, default=None, null=True)
    familyHistory = models.JSONField(blank = True, default=None, null=True)
    lastMensPeriod = models.CharField(max_length=100, blank = True, default=None)
    

    class Meta:
        verbose_name = "Health Record"
        verbose_name_plural = "Health Record"
