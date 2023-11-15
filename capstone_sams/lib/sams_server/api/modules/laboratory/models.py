from django.db import models
from api.modules.patient.models import Patient
from django import forms

class LabResult(models.Model):
    pdfId = models.AutoField(primary_key = True)
    title = models.CharField(blank = False,max_length=128) 
    pdf = models.FileField(blank = False,upload_to='upload-pdf/')
    patient = models.ForeignKey(Patient, on_delete = models.CASCADE)
    user = models.CharField(null = True, blank = True)
    def __str__(self):
        return self.title
    
    class Meta:
        verbose_name = "Laboratory Record"
        verbose_name_plural = "Laboratory Record"

class JsonLabResult(models.Model):
    labresult = models.ForeignKey(LabResult, on_delete = models.CASCADE)
    jsonId = models.AutoField(primary_key = True)
    labresultTitles = models.JSONField()
    collectedOn = models.DateField()
    jsonTables = models.JSONField()
    createdAt = models.DateTimeField(auto_now_add=True) 
    title = models.CharField(blank = False,max_length=128)
    investigation = models.TextField(blank = False,max_length=512)
    patient = models.ForeignKey(Patient, on_delete = models.CASCADE)
    def __str__(self):
        return str(self.jsonId)
