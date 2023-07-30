from django import forms

class PdfImportLabResultForm(forms.Form):
    pdf_upload = forms.FileField()