from django import forms

class CsvImportHealthSymptomForm(forms.Form):
    csv_upload = forms.FileField()