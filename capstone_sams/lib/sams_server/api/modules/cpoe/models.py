
from django.db import models
from api.modules.user.Account import Account
from api.modules.patient.models import Health_Record

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

class Prescribed_Medicine(models.Model):
    prescription = models.ForeignKey(Prescription, on_delete=models.CASCADE)
    medicine = models.ForeignKey(Medicine, on_delete=models.CASCADE)
