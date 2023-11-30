from django import forms

class CsvImportDiagnosticFieldsForm(forms.Form):
    csv_upload = forms.FileField()