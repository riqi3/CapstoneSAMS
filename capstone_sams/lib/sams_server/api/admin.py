from django import forms
from django.contrib import admin, messages
from django.contrib.admin.models import LogEntry
from django.contrib.auth.models import Group
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.contrib.auth.forms import ReadOnlyPasswordHashField
from django.contrib.auth.signals import user_logged_in, user_logged_out
from django.db.models.signals import post_save, pre_delete
from django.dispatch import receiver
from django.urls import path

# from io import StringIO as io
# import csv
from django.urls import reverse
from django.http import HttpResponseRedirect
from django.shortcuts import render
from api.modules.patient.form import CsvImportPatientForm
from api.modules.cpoe.form import CsvImportMedicineForm
from api.modules.laboratory.form import PdfImportLabResultForm
from api.modules.user.models import Account, Data_Log
from api.modules.patient.models import Patient, Health_Record
from api.modules.cpoe.models import Medicine, Prescription
from api.modules.laboratory.models import LabResult

# from api.models import Account, Patient, Data_Log, Prescription, Medicine, Symptom, Health_Record, Comment, Prescribed_Medicine, Patient_Symptom

'''
This is a signal that will create a data log if a user logs in.
'''
@receiver(user_logged_in)
def log_admin_login(sender, request, user, **kwargs):
    data_log = Data_Log(
        event=f"Admin logged in: {user.username}",
        type="Admin Login",
        account=user,
    )
    data_log.save()

'''
This is a signal that will create a data log if a user logs out.
'''
@receiver(user_logged_out)
def log_admin_logout(sender, request, user, **kwargs):
    data_log = Data_Log(
        event=f"Admin logged out: {user.username}",
        type="Admin Logout",
        account=user,
    )
    data_log.save()

'''
This is a signal that will create a data log if an admin user does
anything in the admin form.
'''
@receiver(post_save, sender=LogEntry)
def create_data_log_instance(sender, instance, created, **kwargs):
    if created:
        # Get the admin user associated with this LogEntry
        admin_account = instance.user

        if admin_account:
            # Set the account attribute of the Data_Log instance
            data_log = Data_Log(
                event=f"Admin added/changed a model: {instance}",
                type="Added/Changed Model",
                account=admin_account,
            )
        data_log.save()

'''
This is a signal that will create a data log if an admin user deletes
any data.
'''
@receiver(pre_delete, sender=LogEntry)
def create_data_log_for_deletion(sender, instance, using, **kwargs):
    # Check if the instance is of type LogEntry
    if isinstance(instance, LogEntry):
        # Get the admin account associated with this deletion event (LogEntry model)
        admin_account = instance.user

        if admin_account:
            # Set the account attribute of the Data_Log instance
            data_log = Data_Log(
                event=f"Admin deleted a model: {instance}",
                type="Deleted Model",
                account=admin_account,
            )
            data_log.save()

'''
This is a signal that will create a data log if an admin user deletes
any data.
'''
@receiver(post_save, sender=Patient)
def create_health_record(sender, instance, created, **kwargs):
    if created:
        health_record = Health_Record.objects.create(
            symptoms={"symptoms": "None"},
            diseases={"diseases": "None"},
            patient=instance,
        )
        admin_account = instance.user


COMMON_PASSWORDS = ["password", "12345678", "qwerty", "abc123"] # These are some commonly used passwords that the system will not accept.

'''
This represent the forms that will be shown to the admin when creating a new user.
'''
class UserCreationForm(forms.ModelForm):
    """A form for creating new users. Includes all the required
    fields, plus a repeated password."""

    password1 = forms.CharField(label="Password", widget=forms.PasswordInput)
    password2 = forms.CharField(
        label="Password confirmation", widget=forms.PasswordInput
    )

    class Meta:
        model = Account
        fields = (
            "accountID",
            "username",
            "firstName",
            "middleName",
            "lastName",
            "accountRole",
            "is_active",
            "is_staff",
            "is_superuser",
        )

    def clean_password2(self):
        # Check that the two password entries match
        password1 = self.cleaned_data.get("password1")
        password2 = self.cleaned_data.get("password2")
        if password1 and password2 and password1 != password2:
            raise forms.ValidationError("Passwords don't match")

        # Check for password length
        if len(password1) < 8:
            raise forms.ValidationError("Password must be at least 8 characters long")

        # Check that the password is not entirely numeric
        if password1.isdigit():
            raise forms.ValidationError("Password cannot be entirely numeric")

        # Check that the password is not common
        if password1.lower() in COMMON_PASSWORDS:
            raise forms.ValidationError("Password is too common")
        return password2

    def save(self, commit=True):
        # Save the provided password in hashed format
        user = super(UserCreationForm, self).save(commit=False)
        user.set_password(self.cleaned_data["password1"])
        if commit:
            user.save()
        return user


'''
This represent the forms that will be shown to the admin when updating data of an existing user.
'''
class UserChangeForm(forms.ModelForm):
    """A form for updating users. Includes all the fields on
    the user, but replaces the password field with admin's
    password hash display field.
    """

    password = ReadOnlyPasswordHashField(
        label=("Password"),
        help_text=(
            "Raw passwords are not stored, so there is no way to see "
            "this user's password, but you can change the password "
            'using <a href="../password/">this form</a>.'
        ),
    )

    class Meta:
        model = Account
        fields = (
            "username",
            "password",
            "firstName",
            "middleName",
            "lastName",
            "accountRole",
            "is_active",
            "is_staff",
            "is_superuser",
        )

    def clean_password(self):
        # Regardless of what the user provides, return the initial value.
        # This is done here, rather than on the field, because the
        # field does not have access to the initial value
        return self.initial["password"]

'''
This represent the table that will be shown to the admin looking at the currently stored users.
'''
class UserAdmin(BaseUserAdmin):
    # The forms to add and change user instances
    form = UserChangeForm
    add_form = UserCreationForm

    # The fields to be used in displaying the User model.
    # These override the definitions on the base UserAdmin
    # that reference specific fields on auth.User.
    list_display = (
        "username",
        "firstName",
        "middleName",
        "lastName",
        "accountRole",
        "is_active",
        "is_staff",
        "is_superuser",
    )
    list_filter = ("accountRole", "is_staff", "is_superuser")
    fieldsets = (
        (None, {"fields": ("username", "password")}),
        (
            "Personal info",
            {
                "fields": (
                    "firstName",
                    "middleName",
                    "lastName",
                    "accountRole",
                )
            },
        ),
        ("Permissions", {"fields": ("is_active", "is_staff", "is_superuser")}),
    )
    # add_fieldsets is not a standard ModelAdmin attribute. UserAdmin
    # overrides get_fieldsets to use this attribute when creating a user.
    add_fieldsets = (
        (
            None,
            {
                "classes": ("wide",),
                "fields": (
                    "accountID",
                    "username",
                    "firstName",
                    "middleName",
                    "lastName",
                    "accountRole",
                    "is_active",
                    "is_staff",
                    "is_superuser",
                    "password1",
                    "password2",
                ),
            },
        ),
    )
    search_fields = ("username",)
    ordering = ("username",)
    filter_horizontal = ()

'''
This represent the forms that will be shown to the admin when creating a new patient
and updating existing patients.
'''
class PatientAdminForm(forms.ModelForm):
    class Meta:
        model = Patient
        fields = (
            "patientID",
            "firstName",
            "middleName",
            "lastName",
            "age",
            "gender",
            "birthDate",
            "registration",
            "phone",
            "email",
        )

'''
This represent the table that will be shown to the admin looking at the currently stored patients.
'''
class PatientAdmin(admin.ModelAdmin):
    form = PatientAdminForm
    list_display = (
        "patientID",
        "firstName",
        "middleName",
        "lastName",
        "age",
        "gender",
        "birthDate",
        "registration",
        "phone",
        "email",
    )
    list_filter = ("patientID", "gender", "registration")
    search_fields = (
        "patientID",
        "firstName",
        "middleName",
        "lastName",
        "birthDate",
        "email",
    )

    def get_urls(self):
        urls = super().get_urls()
        new_urls = [
            path("upload-csv/", self.upload_csv),
        ]
        return new_urls + urls

    def upload_csv(self, request):
        if request.method == "POST":
            csv_file = request.FILES["csv_upload"]
            if not csv_file.name.endswith(".csv"):
                messages.warning(request, "The wrong file type was uploaded")
                return HttpResponseRedirect(request.path_info)
            file_data = csv_file.read().decode("utf-8")
            csv_data = file_data.split("\n")
            for x in csv_data:
                fields = x.split(",")
                created = Patient.objects.update_or_create(
                    patientID=fields[0],
                    firstName=fields[1],
                    middleName=fields[2],
                    lastName=fields[3],
                    age=fields[4],
                    gender=fields[5],
                    birthDate=fields[6],
                    registration=fields[7],
                    phone=fields[8],
                    email=fields[9],
                )
            url = reverse("admin:index")
            return HttpResponseRedirect(url)
        form = CsvImportPatientForm()
        data = {"form": form}
        return render(request, "admin/csv_upload.html", data)


class LabResultAdminForm(forms.ModelForm):
    class Meta:
        model = LabResult
        fields = "__all__"


class LabResultAdmin(admin.ModelAdmin):
    form = LabResultAdminForm
    list_display = ("pdfId", "title", "comment", "pdf")

    def get_urls(self):
        urls = super().get_urls()
        new_urls = [
            path("upload-pdf/", self.upload_pdf),
        ]
        return new_urls + urls

    def upload_pdf(self, request):
        if request.method == "POST":
            pdf_file = request.FILES["pdf_upload"]
            if not pdf_file.name.endswith(".pdf"):
                messages.warning(request, "The wrong file type was uploaded")
                return HttpResponseRedirect(request.path_info)

        form = PdfImportLabResultForm()
        data = {"form": form}
        return render(request, "admin/pdf_upload.html", data)

'''
This represent the forms that will be shown to the admin when updating existing data logs.
'''
class DataLogsAdminForm(forms.ModelForm):
    class Meta:
        model = Data_Log
        fields = "__all__"

'''
This represent the table that will be shown to the admin looking at the currently stored data logs.
'''
class DataLogsAdmin(admin.ModelAdmin):
    form = DataLogsAdminForm
    list_display = ("logNum", "event", "date", "type", "account")
    list_filter = ("event", "date", "account", "type")
    search_fields = ("event", "date", "account")


'''
This represent the table that will be shown to the admin looking at the currently stored medicines.
'''
class MedicineAdminForm(forms.ModelForm):
    class Meta:
        model = Medicine
        fields = "__all__"

'''
This represent the table that will be shown to the admin looking at the currently stored medicines.
'''
class MedicineAdmin(admin.ModelAdmin):
    form = MedicineAdminForm
    list_display = ("drugId", "drugCode", "drugName")
    search_fields = ("drugId", "drugCode", "drugName")

    def get_urls(self):
        urls = super().get_urls()
        new_urls = [
            path("upload-csv/", self.upload_csv),
        ]
        return new_urls + urls

    def upload_csv(self, request):
        if request.method == "POST":
            csv_file = request.FILES["csv_upload"]
            if not csv_file.name.endswith(".csv"):
                messages.warning(request, "The wrong file type was uploaded")
                return HttpResponseRedirect(request.path_info)
            file_data = csv_file.read().decode("utf-8")
            csv_data = file_data.split("\n")
            for x in csv_data:
                fields = x.split(",")
                created = Medicine.objects.update_or_create(
                    drugId=fields[0],
                    drugCode=fields[1],
                    drugName=fields[2],
                )
            url = reverse("admin:index")
            return HttpResponseRedirect(url)
        form = CsvImportMedicineForm()
        data = {"form": form}
        return render(request, "admin/csv_upload.html", data)

'''
This represent the forms that will be shown to the admin when creating a new health record
and updating existing health records.
'''
class HealthRecordAdminForm(forms.ModelForm):
    class Meta:
        model = Health_Record
        fields = "__all__"

'''
This represent the table that will be shown to the admin looking at the currently stored health records.
'''
class HealthRecordAdmin(admin.ModelAdmin):
    form = HealthRecordAdminForm
    list_display = ("recordNum", "patient")
    search_fields = ("recordNum",)
    autocomplete_fields = ["patient"]


class PrescriptionAdminForm(forms.ModelForm):
    class Meta:
        model = Prescription
        fields = "__all__"

'''
This represent the table that will be shown to the admin looking at the currently stored prescriptions.
'''
class PrescriptionAdmin(admin.ModelAdmin):
    form = PrescriptionAdminForm
    autocomplete_fields = ["health_record"]
    list_display = (
        "presNum",
        # "dosage",
        # "timeFrame",
        # "amount",
        "medicines",
        "account",
        "health_record",
    )
    list_filter = ("account", "health_record")
    search_fields = ("presNum",)
    autocomplete_fields = ["account", "health_record"]


# class SymptomsAdminForm(forms.ModelForm):
#     class Meta:
#         model = Symptom
#         fields = "__all__"


# class SymptomsAdmin(admin.ModelAdmin):
#     form = SymptomsAdminForm
#     list_display = ("sympNum", "symptom")
#     search_fields = ("sympNum", "symptom")

# Now register the new UserAdmin...
admin.site.register(Account, UserAdmin)
admin.site.register(Patient, PatientAdmin)
admin.site.register(Data_Log, DataLogsAdmin)
admin.site.register(Medicine, MedicineAdmin)
admin.site.register(Health_Record, HealthRecordAdmin)
admin.site.register(Prescription, PrescriptionAdmin)
# admin.site.register(Symptom, SymptomsAdmin)
admin.site.register(LabResult, LabResultAdmin)

# ... and, since we're not using Django's built-in permissions,
# unregister the Group model from admin.
admin.site.unregister(Group)
post_save.connect(create_data_log_instance, sender=LogEntry)
user_logged_in.connect(log_admin_login)
user_logged_out.connect(log_admin_logout)
pre_delete.connect(create_data_log_for_deletion)
