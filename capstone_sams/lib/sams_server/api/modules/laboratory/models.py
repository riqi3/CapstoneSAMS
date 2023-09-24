from django.db import models
from api.modules.patient.models import Patient
from django import forms

class LabResult(models.Model):
    pdfId = models.AutoField(primary_key = True)
    title = models.CharField(blank = False,max_length=128)
    comment = models.TextField(blank = False,max_length=512)
    pdf = models.FileField(blank = False,upload_to='upload-pdf/')
    patient = models.ForeignKey(Patient, on_delete = models.CASCADE)

    def __str__(self):
        return self.title

class JsonLabResult(models.Model):
    labresult = models.ForeignKey(LabResult, on_delete = models.CASCADE)
    jsonId = models.AutoField(primary_key = True)
    labresultTitles = models.JSONField()
    jsonTables = models.JSONField()
    createdAt = models.DateTimeField(auto_now_add=True)
    title = models.CharField(blank = False,max_length=128)
    comment = models.TextField(blank = False,max_length=512)
    patient = models.ForeignKey(Patient, on_delete = models.CASCADE)
    # patientID = models.CharField(max_length=100)
    def __str__(self):
        return str(self.jsonId)
 
    # class Meta:
    #     ordering = ['title']
     
    # def __str__(self):
    #     return f"{self.title}"

# class UploadLabResult(forms.ModelForm):
#     class Meta:
#         model = LabResult
#         fields = ('title', 'comment','pdf')

# class pdfJson(models.Model):
#     text = models.TextField()

# import os
# import datetime
# from django import forms
# Create your models here.



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





