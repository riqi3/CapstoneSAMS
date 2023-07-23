from django import forms

class CsvImportPatientForm(forms.Form):
    csv_upload = forms.FileField()