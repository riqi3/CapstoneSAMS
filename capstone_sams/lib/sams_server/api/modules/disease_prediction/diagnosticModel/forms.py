from django import forms

class CsvImportDiagnosticFieldForm(forms.Form):
    csv_upload = forms.FileField()