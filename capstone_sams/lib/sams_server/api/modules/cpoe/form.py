from django import forms

class CsvImportMedicineForm(forms.Form):
    csv_upload = forms.FileField()