from django.db import models
from django import forms


class DrugModel(models.Model):
    bnf = models.CharField(max_length=20)
    description = models.CharField(max_length=128)

    class Meta:
        ordering = ["bnf"]

    def __str__(self):
        return f"{self.bnf}"


# class InsertDrug(forms.ModelForm):
#     class Meta:
#         model = DrugModel
#         fields = ( 'bnf','description' )


class CSVDrug(models.Model):
    title = models.CharField(max_length=128)
    description = models.TextField(max_length=512)
    csv = models.FileField(upload_to="upload/")

    class Meta:
        ordering = ["title"]

    def __str__(self):
        return f"{self.title}"


class UploadDrugFile(forms.Form):
    csv_file = forms.FileField(
        required=False,
        widget=forms.FileInput(
            attrs={
                "class": "form-control",
                "placeholder": "Upload csv file",
                "help_text": "Choose a .csv file to upload the list of drugs in bulk",
            }
        ),
    )
    # class Meta:
    #     model = CSVDrug
    #     fields = ('title', 'description', 'csv')
