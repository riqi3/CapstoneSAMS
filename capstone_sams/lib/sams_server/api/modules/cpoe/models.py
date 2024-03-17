
from django.db import models
from api.modules.user.models import Account
from api.modules.patient.models import Medical_Record, Patient, Present_Illness, Health_Record
from api.modules.disease_prediction.cdssModel.models import HealthSymptom

'''
This model represent the comments that
each user will inputted and stored into the system.
'''
class Comment(models.Model):
    #Comment Attributes
    comNum = models.AutoField(primary_key = True)
    content = models.CharField(max_length = 3000)
    account = models.ForeignKey(Account, on_delete = models.CASCADE)
    health_record = models.ForeignKey(Medical_Record, on_delete = models.CASCADE)

'''
This model represent the prescriptions that
physicians will input and store into the system.
'''
class Prescription(models.Model):
    #Prescription Attributes
    presNum = models.AutoField(primary_key = True)
    medicines = models.JSONField(blank = True, default=None)
    account = models.ForeignKey(Account, on_delete = models.CASCADE)
    # health_record = models.ForeignKey(Health_Record, on_delete = models.CASCADE)
    patient = models.ForeignKey(Patient, on_delete = models.CASCADE) 
    # disease = models.CharField(max_length=255, null=True, blank=True)    
    illness = models.ForeignKey(Present_Illness, on_delete = models.CASCADE) 

    class Meta:
        verbose_name = "Prescription Record"
        verbose_name_plural = "Prescription Record"

'''
This model represent the medicines currently
stored into the system.
'''
class Medicine(models.Model):
    #Medicine Attributes
    drugId = models.CharField(primary_key = True)
    drugCode = models.CharField(blank = False)
    drugName = models.CharField(blank = False)

    class Meta:
        verbose_name = "Medicine Record"
        verbose_name_plural = "Medicine Record"