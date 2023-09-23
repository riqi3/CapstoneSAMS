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

from api.modules.disease_prediction.cdssModel.models import HealthSymptom
from api.modules.disease_prediction.cdssModel.views import train_disease_prediction_model

# from api.models import Account, Patient, Data_Log, Prescription, Medicine, Symptom, Health_Record, Comment, Prescribed_Medicine, Patient_Symptom


@receiver(user_logged_in)
def log_admin_login(sender, request, user, **kwargs):
    data_log = Data_Log(
        event=f"Admin logged in: {user.username}",
        type="Admin Login",
        account=user,
    )
    data_log.save()


@receiver(user_logged_out)
def log_admin_logout(sender, request, user, **kwargs):
    data_log = Data_Log(
        event=f"Admin logged out: {user.username}",
        type="Admin Logout",
        account=user,
    )
    data_log.save()


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


@receiver(post_save, sender=Patient)
def create_health_record(sender, instance, created, **kwargs):
    if created:
        health_record = Health_Record.objects.create(
            symptoms={"symptoms": "None"},
            diseases={"diseases": "None"},
            patient=instance,
        )
        admin_account = instance.user


COMMON_PASSWORDS = ["password", "12345678", "qwerty", "abc123"]


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


class DataLogsAdminForm(forms.ModelForm):
    class Meta:
        model = Data_Log
        fields = "__all__"


class DataLogsAdmin(admin.ModelAdmin):
    form = DataLogsAdminForm
    list_display = ("logNum", "event", "date", "type", "account")
    list_filter = ("event", "date", "account", "type")
    search_fields = ("event", "date", "account")


class MedicineAdminForm(forms.ModelForm):
    class Meta:
        model = Medicine
        fields = "__all__"


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


class HealthRecordAdminForm(forms.ModelForm):
    class Meta:
        model = Health_Record
        fields = "__all__"


class HealthRecordAdmin(admin.ModelAdmin):
    form = HealthRecordAdminForm
    list_display = ("recordNum", "patient")
    search_fields = ("recordNum",)
    autocomplete_fields = ["patient"]


class PrescriptionAdminForm(forms.ModelForm):
    class Meta:
        model = Prescription
        fields = "__all__"


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

class HealthSymptomAdmin(admin.ModelAdmin):
    change_list_template = "admin/train_model.html"
    list_display = [
    "prognosis",
    "itching",
    "skin_rash",
    "nodal_skin_eruptions",
    "continuous_sneezing",
    "shivering",
    "chills",
    "joint_pain",
    "stomach_pain",
    "acidity",
    "ulcers_on_tongue",
    "muscle_wasting",
    "vomiting",
    "burning_micturition",
    "spotting_urination",
    "fatigue",
    "weight_gain",
    "anxiety",
    "cold_hands_and_feets",
    "mood_swings",
    "weight_loss",
    "restlessness",
    "lethargy",
    "patches_in_throat",
    "irregular_sugar_level",
    "cough",
    "high_fever",
    "sunken_eyes",
    "breathlessness",
    "sweating",
    "dehydration",
    "indigestion",
    "headache",
    "yellowish_skin",
    "dark_urine",
    "nausea",
    "loss_of_appetite",
    "pain_behind_the_eyes",
    "back_pain",
    "constipation",
    "abdominal_pain",
    "diarrhoea",
    "mild_fever",
    "yellow_urine",
    "yellowing_of_eyes",
    "acute_liver_failure",
    "fluid_overload",
    "swelling_of_stomach",
    "swelled_lymph_nodes",
    "malaise",
    "blurred_and_distorted_vision",
    "phlegm",
    "throat_irritation",
    "redness_of_eyes",
    "sinus_pressure",
    "runny_nose",
    "congestion",
    "chest_pain",
    "weakness_in_limbs",
    "fast_heart_rate",
    "pain_during_bowel_movements",
    "pain_in_anal_region",
    "bloody_stool",
    "irritation_in_anus",
    "neck_pain",
    "dizziness",
    "cramps",
    "bruising",
    "obesity",
    "swollen_legs",
    "swollen_blood_vessels",
    "puffy_face_and_eyes",
    "enlarged_thyroid",
    "brittle_nails",
    "swollen_extremities",
    "excessive_hunger",
    "extra_marital_contacts",
    "drying_and_tingling_lips",
    "slurred_speech",
    "knee_pain",
    "hip_joint_pain",
    "muscle_weakness",
    "stiff_neck",
    "swelling_joints",
    "movement_stiffness",
    "spinning_movements",
    "loss_of_balance",
    "unsteadiness",
    "weakness_of_one_body_side",
    "loss_of_smell",
    "bladder_discomfort",
    "foul_smell_of_urine",
    "continuous_feel_of_urine",
    "passage_of_gases",
    "internal_itching",
    "toxic_look_typhos",
    "depression",
    "irritability",
    "muscle_pain",
    "altered_sensorium",
    "red_spots_over_body",
    "belly_pain",
    "abnormal_menstruation",
    "dischromic_patches",
    "watering_from_eyes",
    "increased_appetite",
    "polyuria",
    "family_history",
    "mucoid_sputum",
    "rusty_sputum",
    "lack_of_concentration",
    "visual_disturbances",
    "receiving_blood_transfusion",
    "receiving_unsterile_injections",
    "coma",
    "stomach_bleeding",
    "distention_of_abdomen",
    "history_of_alcohol_consumption",
    "fluid_overload_2",
    "blood_in_sputum",
    "prominent_veins_on_calf",
    "palpitations",
    "painful_walking",
    "pus_filled_pimples",
    "blackheads",
    "scurrying",
    "skin_peeling",
    "silver_like_dusting",
    "small_dents_in_nails",
    "inflammatory_nails",
    "blister",
    "red_sore_around_nose",
    "yellow_crust_ooze"
]
    list_filter = ["prognosis"]  
    search_fields = ["prognosis"] 

    ordering = ('-id',)

    def get_urls(self):
        urls = super().get_urls()
        new_urls = [
            path("retrain_model/", self.retrain_model, name="admin_retrain_model"),
        ]
        return new_urls + urls 
    
    def retrain_model(self, request):
        if request.method == 'POST':
            success, message = train_disease_prediction_model()
            if success:
                self.message_user(request, f"Model retraining completed successfully: {message}")
            else:
                self.message_user(request, f"Model retraining failed: {message}", level=admin.ERROR)

        context = self.admin_site.each_context(request)
        return HttpResponseRedirect("../")
    
    retrain_model.short_description = "Retrain Model"
    


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
admin.site.register(HealthSymptom, HealthSymptomAdmin)
# ... and, since we're not using Django's built-in permissions,
# unregister the Group model from admin.
admin.site.unregister(Group)
post_save.connect(create_data_log_instance, sender=LogEntry)
user_logged_in.connect(log_admin_login)
user_logged_out.connect(log_admin_logout)
pre_delete.connect(create_data_log_for_deletion)
