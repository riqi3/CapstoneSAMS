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
from IPython.display import display, HTML
from PIL import Image, ImageDraw, ImageFont 
import random   
import os
import csv
from api.modules.disease_prediction.cdssModel.forms import CsvImportHealthSymptomForm 
from .utils import delete_profile_photo 
# from io import StringIO as io
# import csv
from django.urls import reverse
from django.http import HttpResponseRedirect, JsonResponse
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
This is a signal that will create a data log if an admin user does
anything in the admin form.
'''
@receiver(post_save, sender=LabResult)
def create_log_for_pdf_upload(sender, instance, created, **kwargs):
    if created:
        # Get the admin user associated with this LogEntry
        account = instance.user

        if account:
            # Set the account attribute of the Data_Log instance
            data_log = Data_Log(
                event=f"User added/changed a model: {instance}",
                type="Added/Changed Model",
                account=account,
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
            "profile_photo",
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
        photo = self.photo_generator(user)
        user.profile_photo = os.path.basename(photo)
        if commit:
            user.save()
        return user

    
    def photo_generator(self, user):
        width = 300
        height = 300
        font_size = 200
        font_path  = 'sams_server/static/fonts/Poppins-Regular.ttf'
        fontColor = (255,255,255)
        arr = []
        for rand in range(3):
            rand = random.randint(0,200) 
            arr.append(rand)
            backgroundColor = tuple(arr)
            print(backgroundColor)
        img = Image.new("RGBA", (width, height), backgroundColor)
        draw = ImageDraw.Draw(img)
        font = ImageFont.truetype(font_path, size=font_size)
        letter = str(user.firstName)[0].upper() 
        bbox = font.getbbox(letter)
        x = (width - (bbox[2] - bbox[0])) // 2
        y = (height - (bbox[3] - bbox[1])) // 2
        draw.text((x, y - bbox[1]), letter, font=font, fill=fontColor)
        save_folder = 'upload-photo'
        os.makedirs(save_folder, exist_ok=True)
        img_path = os.path.join(save_folder, f'{user.accountID}_{user.firstName}{user.lastName}_profilepic.png')
        img.save(img_path)
        return img_path
     


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
            "accountID",
            "username",
            "password",
            "firstName",
            "middleName",
            "lastName",
            "accountRole",
            "is_active",
            "is_staff",
            "is_superuser",
            "profile_photo",
        )

    def clean_password(self):
        # Regardless of what the user provides, return the initial value.
        # This is done here, rather than on the field, because the
        # field does not have access to the initial value
        return self.initial["password"]
     
    # def delete_profile_photo(user):
    #     folder_path = 'upload-photo/'
    #     file_name = f'{user.accountID}_{user.firstName}{user.lastName}_profilepic.png'
    #     file_path = os.path.join(folder_path, file_name)
    #     if os.path.exists(file_path):
    #         os.remove(file_path)
    #         print(f"Deleted file: {file_path}")
    #     else:
    #         print(f"File does not exist: {file_path}")

    
    # def save(self, commit=True): 
    #     admin = super(UserChangeForm, self).save(commit=False) 
    #     photo = self.delete_profile_photo(admin)
    #     admin.profile_photo = os.path.basename(photo)
    #     if commit:
    #         admin.save()
    #     return admin
 
 

'''
This represent the table that will be shown to the admin looking at the currently stored users.
'''
class UserAdmin(BaseUserAdmin):
    
 
    # The forms to add and change user instances
    form = UserChangeForm
    add_form = UserCreationForm 
    actions = ['delete_model']
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
        "profile_photo",
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
                    "profile_photo",
                ),
            },
        ),
    )
    search_fields = ("username",)
    ordering = ("username",)
    filter_horizontal = ()


    # def delete_queryset(self, request, queryset):
    #     for obj in queryset: 
    #         if obj.file_field:
    #             delete_profile_photo(obj)   
    #         obj.delete()  
    #         queryset.delete()
    #     super(UserAdmin, self).delete_queryset(request, queryset)
 
    def delete_queryset(self, request, queryset):
         for obj in queryset:
            print(obj)
            folder_path = 'upload-photo/'
            file_name = f'{obj.accountID}_{obj.firstName}{obj.lastName}_profilepic.png'
            print(file_name)
            file_path = os.path.join(folder_path, file_name)
            print(file_path)
            if os.path.exists(file_path):
                os.remove(file_path)
                obj.delete()
                print(f"Deleted file: {file_path}")
            else:
                print(f"File does not exist: {file_path}")
    def delete_model(self, request,  obj):
        print(obj)
        folder_path = 'upload-photo/'
        file_name = f'{obj.accountID}_{obj.firstName}{obj.lastName}_profilepic.png'
        print(file_name)
        file_path = os.path.join(folder_path, file_name)
        print(file_path)
        if os.path.exists(file_path):
            os.remove(file_path)
            obj.delete()
            print(f"Deleted file: {file_path}")
        else:
            print(f"File does not exist: {file_path}")
        
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
    
    # def csv_to_html_table(self, request, num_rows=10): 
    #     if request.method == 'POST':
    #         csv_file = request.FILES['csv_upload']
    #         if not csv_file.name.endswith('.csv'):
    #             messages.warning(request, 'The wrong file type was uploaded')
    #             return HttpResponseRedirect(request.path_info)
    #         table_html = "<table>"
    #         with open(csv_file, 'r', newline='') as csv_file:
    #             csv_reader = csv.reader(csv_file) 
    #             for i, row in enumerate(csv_reader):
    #                 if i >= num_rows:
    #                     break
    #                 table_html += "<tr>"
    #                 for cell in row:
    #                     table_html += f"<td>{cell}</td>"
    #                 table_html += "</tr>"
    #         table_html += "</table>"
    #         return table_html
    #     num_rows_to_read = 10
    #     return render(request, "admin/csv_upload.html", {'html_table': table_html, 'row_count': num_rows_to_read})


    # def csv_to_html_table(request, num_rows=10):
    #     if request.method == 'POST':
    #         csv_file = request.FILES['csv_upload']
    #         if not csv_file.name.endswith('.csv'):
    #             messages.warning(request, 'The wrong file type was uploaded')
    #             return HttpResponseRedirect(request.path_info)
        
    #         csv_data = []
    #         with open(csv_file, 'r', newline='') as csv_file:
    #             csv_reader = csv.reader(csv_file)
    #             for row in csv_reader:
    #                 csv_data.append(row)
        
    #         num_rows_to_read = 10   
        
    #         return render(request, "admin/csv_upload.html", {'csv_data': csv_data, 'row_count': num_rows_to_read})

    #     num_rows_to_read = 10
    #     return render(request, "admin/csv_upload.html", {'csv_data': [], 'row_count': num_rows_to_read})
 
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
    autocomplete_fields = ["patient"]
    list_display = (
        "presNum",
        "disease",
        # "dosage",
        # "timeFrame",
        # "amount",
        "medicines",
        "account",
        "patient",
        
    )
    list_filter = ("account", "patient")
    search_fields = ("presNum",)
    autocomplete_fields = ["account", "patient"]


class HealthSymptomAdminForm(forms.ModelForm):
    class Meta:
        model = HealthSymptom
        fields = "__all__"
class HealthSymptomAdmin(admin.ModelAdmin):
    form = HealthSymptomAdminForm
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
            path("upload-csv/", self.upload_csv, name="upload-csv"),
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
            for x in csv_data[1:]:
                fields = x.split(",")
                created = HealthSymptom.objects.update_or_create(
                    itching=fields[0],
                    skin_rash=fields[1],
                    nodal_skin_eruptions=fields[2],
                    continuous_sneezing=fields[3],
                    shivering=fields[4],
                    chills=fields[5],
                    joint_pain=fields[6],
                    stomach_pain=fields[7],
                    acidity=fields[8],
                    ulcers_on_tongue=fields[9],
                    muscle_wasting=fields[10],
                    vomiting=fields[11],
                    burning_micturition=fields[12],
                    spotting_urination=fields[13],
                    fatigue=fields[14],
                    weight_gain=fields[15],
                    anxiety=fields[16],
                    cold_hands_and_feets=fields[17],
                    mood_swings=fields[18],
                    weight_loss=fields[19],
                    restlessness=fields[20],
                    lethargy=fields[21],
                    patches_in_throat=fields[22],
                    irregular_sugar_level=fields[23],
                    cough=fields[24],
                    high_fever=fields[25],
                    sunken_eyes=fields[26],
                    breathlessness=fields[27],
                    sweating=fields[28],
                    dehydration=fields[29],
                    indigestion=fields[30],
                    headache=fields[31],
                    yellowish_skin=fields[32],
                    dark_urine=fields[33],
                    nausea=fields[34],
                    loss_of_appetite=fields[35],
                    pain_behind_the_eyes=fields[36],
                    back_pain=fields[37],
                    constipation=fields[38],
                    abdominal_pain=fields[39],
                    diarrhoea=fields[40],
                    mild_fever=fields[41],
                    yellow_urine=fields[42],
                    yellowing_of_eyes=fields[43],
                    acute_liver_failure=fields[44],
                    fluid_overload=fields[45],
                    swelling_of_stomach=fields[46],
                    swelled_lymph_nodes=fields[47],
                    malaise=fields[48],
                    blurred_and_distorted_vision=fields[49],
                    phlegm=fields[50],
                    throat_irritation=fields[51],
                    redness_of_eyes=fields[52],
                    sinus_pressure=fields[53],
                    runny_nose=fields[54],
                    congestion=fields[55],
                    chest_pain=fields[56],
                    weakness_in_limbs=fields[57],
                    fast_heart_rate=fields[58],
                    pain_during_bowel_movements=fields[59],
                    pain_in_anal_region=fields[60],
                    bloody_stool=fields[61],
                    irritation_in_anus=fields[62],
                    neck_pain=fields[63],
                    dizziness=fields[64],
                    cramps=fields[65],
                    bruising=fields[66],
                    obesity=fields[67],
                    swollen_legs=fields[68],
                    swollen_blood_vessels=fields[69],
                    puffy_face_and_eyes=fields[70],
                    enlarged_thyroid=fields[71],
                    brittle_nails=fields[72],
                    swollen_extremities=fields[73],
                    excessive_hunger=fields[74],
                    extra_marital_contacts=fields[75],
                    drying_and_tingling_lips=fields[76],
                    slurred_speech=fields[77],
                    knee_pain=fields[78],
                    hip_joint_pain=fields[79],
                    muscle_weakness=fields[80],
                    stiff_neck=fields[81],
                    swelling_joints=fields[82],
                    movement_stiffness=fields[83],
                    spinning_movements=fields[84],
                    loss_of_balance=fields[85],
                    unsteadiness=fields[86],
                    weakness_of_one_body_side=fields[87],
                    loss_of_smell=fields[88],
                    bladder_discomfort=fields[89],
                    foul_smell_of_urine=fields[90],
                    continuous_feel_of_urine=fields[91],
                    passage_of_gases=fields[92],
                    internal_itching=fields[93],
                    toxic_look_typhos=fields[94],
                    depression=fields[95],
                    irritability=fields[96],
                    muscle_pain=fields[97],
                    altered_sensorium=fields[98],
                    red_spots_over_body=fields[99],
                    belly_pain=fields[100],
                    abnormal_menstruation=fields[101],
                    dischromic_patches=fields[102],
                    watering_from_eyes=fields[103],
                    increased_appetite=fields[104],
                    polyuria=fields[105],
                    family_history=fields[106],
                    mucoid_sputum=fields[107],
                    rusty_sputum=fields[108],
                    lack_of_concentration=fields[109],
                    visual_disturbances=fields[110],
                    receiving_blood_transfusion=fields[111],
                    receiving_unsterile_injections=fields[112],
                    coma=fields[113],
                    stomach_bleeding=fields[114],
                    distention_of_abdomen=fields[115],
                    history_of_alcohol_consumption=fields[116],
                    fluid_overload_2=fields[117],
                    blood_in_sputum=fields[118],
                    prominent_veins_on_calf=fields[119],
                    palpitations=fields[120],
                    painful_walking=fields[121],
                    pus_filled_pimples=fields[122],
                    blackheads=fields[123],
                    scurrying=fields[124],
                    skin_peeling=fields[125],
                    silver_like_dusting=fields[126],
                    small_dents_in_nails=fields[127],
                    inflammatory_nails=fields[128],
                    blister=fields[129],
                    red_sore_around_nose=fields[130],
                    yellow_crust_ooze=fields[131],
                    prognosis=fields[132]
                )
            url = reverse("admin:index")
            return HttpResponseRedirect(url)
        form = CsvImportHealthSymptomForm()
        data = {"form": form}
        return render(request, "admin/csv_upload.html", data)
    
    def retrain_model(self, request):
        try:
            if request.method == 'POST':
                success, message = train_disease_prediction_model()
                if success:
                    self.message_user(request, f"Model retraining: {message}")
                else:
                    self.message_user(request, f"Model retraining failed: {message}")
            else:
                raise ValueError("Invalid request method")

        except Exception as e:
            error_message = f"An error occurred during model retraining: {str(e)}"
            return JsonResponse({'success': False, 'message': error_message})

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
