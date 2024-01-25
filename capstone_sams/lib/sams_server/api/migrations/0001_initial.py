# Generated by Django 5.0.1 on 2024-01-25 09:57

import django.db.models.deletion
import uuid
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='DiagnosticFields',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('disease', models.CharField(max_length=255)),
                ('fever', models.CharField(choices=[('Yes', 'Yes'), ('No', 'No')], max_length=3)),
                ('cough', models.CharField(choices=[('Yes', 'Yes'), ('No', 'No')], max_length=3)),
                ('fatigue', models.CharField(choices=[('Yes', 'Yes'), ('No', 'No')], max_length=3)),
                ('difficulty_breathing', models.CharField(choices=[('Yes', 'Yes'), ('No', 'No')], max_length=3)),
                ('age', models.IntegerField()),
                ('gender', models.CharField(choices=[('Male', 'Male'), ('Female', 'Female')], max_length=10)),
                ('blood_pressure', models.CharField(choices=[('Low', 'Low'), ('Normal', 'Normal'), ('High', 'High')], max_length=10)),
                ('cholesterol_level', models.CharField(choices=[('Low', 'Low'), ('Normal', 'Normal'), ('High', 'High')], max_length=10)),
                ('outcome_variable', models.CharField(choices=[('Positive', 'Positive'), ('Negative', 'Negative')], max_length=10)),
            ],
            options={
                'verbose_name': 'Diagnostic Dataset',
                'verbose_name_plural': 'Diagnostic Dataset',
            },
        ),
        migrations.CreateModel(
            name='Health_Record',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
            ],
            options={
                'verbose_name': 'Health Record',
                'verbose_name_plural': 'Health Record',
            },
        ),
        migrations.CreateModel(
            name='HealthSymptom',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('itching', models.IntegerField()),
                ('skin_rash', models.IntegerField()),
                ('nodal_skin_eruptions', models.IntegerField()),
                ('continuous_sneezing', models.IntegerField()),
                ('shivering', models.IntegerField()),
                ('chills', models.IntegerField()),
                ('joint_pain', models.IntegerField()),
                ('stomach_pain', models.IntegerField()),
                ('acidity', models.IntegerField()),
                ('ulcers_on_tongue', models.IntegerField()),
                ('muscle_wasting', models.IntegerField()),
                ('vomiting', models.IntegerField()),
                ('burning_micturition', models.IntegerField()),
                ('spotting_urination', models.IntegerField()),
                ('fatigue', models.IntegerField()),
                ('weight_gain', models.IntegerField()),
                ('anxiety', models.IntegerField()),
                ('cold_hands_and_feets', models.IntegerField()),
                ('mood_swings', models.IntegerField()),
                ('weight_loss', models.IntegerField()),
                ('restlessness', models.IntegerField()),
                ('lethargy', models.IntegerField()),
                ('patches_in_throat', models.IntegerField()),
                ('irregular_sugar_level', models.IntegerField()),
                ('cough', models.IntegerField()),
                ('high_fever', models.IntegerField()),
                ('sunken_eyes', models.IntegerField()),
                ('breathlessness', models.IntegerField()),
                ('sweating', models.IntegerField()),
                ('dehydration', models.IntegerField()),
                ('indigestion', models.IntegerField()),
                ('headache', models.IntegerField()),
                ('yellowish_skin', models.IntegerField()),
                ('dark_urine', models.IntegerField()),
                ('nausea', models.IntegerField()),
                ('loss_of_appetite', models.IntegerField()),
                ('pain_behind_the_eyes', models.IntegerField()),
                ('back_pain', models.IntegerField()),
                ('constipation', models.IntegerField()),
                ('abdominal_pain', models.IntegerField()),
                ('diarrhoea', models.IntegerField()),
                ('mild_fever', models.IntegerField()),
                ('yellow_urine', models.IntegerField()),
                ('yellowing_of_eyes', models.IntegerField()),
                ('acute_liver_failure', models.IntegerField()),
                ('fluid_overload', models.IntegerField()),
                ('swelling_of_stomach', models.IntegerField()),
                ('swelled_lymph_nodes', models.IntegerField()),
                ('malaise', models.IntegerField()),
                ('blurred_and_distorted_vision', models.IntegerField()),
                ('phlegm', models.IntegerField()),
                ('throat_irritation', models.IntegerField()),
                ('redness_of_eyes', models.IntegerField()),
                ('sinus_pressure', models.IntegerField()),
                ('runny_nose', models.IntegerField()),
                ('congestion', models.IntegerField()),
                ('chest_pain', models.IntegerField()),
                ('weakness_in_limbs', models.IntegerField()),
                ('fast_heart_rate', models.IntegerField()),
                ('pain_during_bowel_movements', models.IntegerField()),
                ('pain_in_anal_region', models.IntegerField()),
                ('bloody_stool', models.IntegerField()),
                ('irritation_in_anus', models.IntegerField()),
                ('neck_pain', models.IntegerField()),
                ('dizziness', models.IntegerField()),
                ('cramps', models.IntegerField()),
                ('bruising', models.IntegerField()),
                ('obesity', models.IntegerField()),
                ('swollen_legs', models.IntegerField()),
                ('swollen_blood_vessels', models.IntegerField()),
                ('puffy_face_and_eyes', models.IntegerField()),
                ('enlarged_thyroid', models.IntegerField()),
                ('brittle_nails', models.IntegerField()),
                ('swollen_extremities', models.IntegerField()),
                ('excessive_hunger', models.IntegerField()),
                ('extra_marital_contacts', models.IntegerField()),
                ('drying_and_tingling_lips', models.IntegerField()),
                ('slurred_speech', models.IntegerField()),
                ('knee_pain', models.IntegerField()),
                ('hip_joint_pain', models.IntegerField()),
                ('muscle_weakness', models.IntegerField()),
                ('stiff_neck', models.IntegerField()),
                ('swelling_joints', models.IntegerField()),
                ('movement_stiffness', models.IntegerField()),
                ('spinning_movements', models.IntegerField()),
                ('loss_of_balance', models.IntegerField()),
                ('unsteadiness', models.IntegerField()),
                ('weakness_of_one_body_side', models.IntegerField()),
                ('loss_of_smell', models.IntegerField()),
                ('bladder_discomfort', models.IntegerField()),
                ('foul_smell_of_urine', models.IntegerField()),
                ('continuous_feel_of_urine', models.IntegerField()),
                ('passage_of_gases', models.IntegerField()),
                ('internal_itching', models.IntegerField()),
                ('toxic_look_typhos', models.IntegerField()),
                ('depression', models.IntegerField()),
                ('irritability', models.IntegerField()),
                ('muscle_pain', models.IntegerField()),
                ('altered_sensorium', models.IntegerField()),
                ('red_spots_over_body', models.IntegerField()),
                ('belly_pain', models.IntegerField()),
                ('abnormal_menstruation', models.IntegerField()),
                ('dischromic_patches', models.IntegerField()),
                ('watering_from_eyes', models.IntegerField()),
                ('increased_appetite', models.IntegerField()),
                ('polyuria', models.IntegerField()),
                ('family_history', models.IntegerField()),
                ('mucoid_sputum', models.IntegerField()),
                ('rusty_sputum', models.IntegerField()),
                ('lack_of_concentration', models.IntegerField()),
                ('visual_disturbances', models.IntegerField()),
                ('receiving_blood_transfusion', models.IntegerField()),
                ('receiving_unsterile_injections', models.IntegerField()),
                ('coma', models.IntegerField()),
                ('stomach_bleeding', models.IntegerField()),
                ('distention_of_abdomen', models.IntegerField()),
                ('history_of_alcohol_consumption', models.IntegerField()),
                ('fluid_overload_2', models.IntegerField()),
                ('blood_in_sputum', models.IntegerField()),
                ('prominent_veins_on_calf', models.IntegerField()),
                ('palpitations', models.IntegerField()),
                ('painful_walking', models.IntegerField()),
                ('pus_filled_pimples', models.IntegerField()),
                ('blackheads', models.IntegerField()),
                ('scurrying', models.IntegerField()),
                ('skin_peeling', models.IntegerField()),
                ('silver_like_dusting', models.IntegerField()),
                ('small_dents_in_nails', models.IntegerField()),
                ('inflammatory_nails', models.IntegerField()),
                ('blister', models.IntegerField()),
                ('red_sore_around_nose', models.IntegerField()),
                ('yellow_crust_ooze', models.IntegerField()),
                ('prognosis', models.CharField(max_length=255)),
            ],
            options={
                'verbose_name': 'Symptom Dataset',
                'verbose_name_plural': 'Symptom Dataset',
            },
        ),
        migrations.CreateModel(
            name='Medical_Record',
            fields=[
                ('recordNum', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('illnesses', models.JSONField(blank=True, default=None, null=True)),
                ('allergies', models.JSONField(blank=True, default=None, null=True)),
                ('pastDiseases', models.JSONField(blank=True, default=None, null=True)),
                ('familyHistory', models.JSONField(blank=True, default=None, null=True)),
                ('lastMensPeriod', models.CharField(blank=True, default=None, max_length=100)),
            ],
            options={
                'verbose_name': 'Medical Record',
                'verbose_name_plural': 'Medical Record',
            },
        ),
        migrations.CreateModel(
            name='Medicine',
            fields=[
                ('drugId', models.CharField(primary_key=True, serialize=False)),
                ('drugCode', models.CharField()),
                ('drugName', models.CharField()),
            ],
            options={
                'verbose_name': 'Medicine Record',
                'verbose_name_plural': 'Medicine Record',
            },
        ),
        migrations.CreateModel(
            name='Comment',
            fields=[
                ('comNum', models.AutoField(primary_key=True, serialize=False)),
                ('content', models.CharField(max_length=3000)),
                ('account', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
                ('health_record', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.medical_record')),
            ],
        ),
        migrations.CreateModel(
            name='Patient',
            fields=[
                ('patientID', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('firstName', models.CharField(max_length=100)),
                ('middleInitial', models.CharField(max_length=1)),
                ('lastName', models.CharField(max_length=100)),
                ('age', models.IntegerField()),
                ('gender', models.CharField(choices=[('M', 'Male'), ('F', 'Female')])),
                ('patientStatus', models.CharField(choices=[('Married', 'Married'), ('Widowed', 'Widowed'), ('Separated', 'Separated'), ('Divorced', 'Divorced'), ('Single', 'Single')])),
                ('birthDate', models.DateField()),
                ('course', models.CharField(max_length=300)),
                ('yrLevel', models.IntegerField()),
                ('studNumber', models.CharField(max_length=100)),
                ('address', models.CharField()),
                ('height', models.FloatField()),
                ('weight', models.FloatField()),
                ('phone', models.CharField(blank=True, max_length=11, null=True)),
                ('email', models.CharField(blank=True, max_length=50, null=True)),
                ('assignedPhysician', models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'verbose_name': 'Patient Record',
                'verbose_name_plural': 'Patient Record',
            },
        ),
        migrations.AddField(
            model_name='medical_record',
            name='patient',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.patient'),
        ),
        migrations.CreateModel(
            name='LabResult',
            fields=[
                ('pdfId', models.AutoField(primary_key=True, serialize=False)),
                ('title', models.CharField(max_length=128)),
                ('pdf', models.FileField(upload_to='upload-pdf/')),
                ('user', models.CharField(blank=True, null=True)),
                ('patient', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.patient')),
            ],
            options={
                'verbose_name': 'Laboratory Record',
                'verbose_name_plural': 'Laboratory Record',
            },
        ),
        migrations.CreateModel(
            name='JsonLabResult',
            fields=[
                ('jsonId', models.AutoField(primary_key=True, serialize=False)),
                ('labresultTitles', models.JSONField()),
                ('collectedOn', models.DateField()),
                ('jsonTables', models.JSONField()),
                ('createdAt', models.DateTimeField(auto_now_add=True)),
                ('title', models.CharField(max_length=128)),
                ('investigation', models.TextField(max_length=512)),
                ('labresult', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.labresult')),
                ('patient', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.patient')),
            ],
        ),
        migrations.CreateModel(
            name='Contact_Person',
            fields=[
                ('contactId', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('fullName', models.CharField(max_length=100)),
                ('phone', models.CharField(max_length=11)),
                ('address', models.CharField()),
                ('patient', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.patient')),
            ],
        ),
        migrations.CreateModel(
            name='Prescription',
            fields=[
                ('presNum', models.AutoField(primary_key=True, serialize=False)),
                ('medicines', models.JSONField(blank=True, default=None)),
                ('disease', models.CharField(blank=True, max_length=255, null=True)),
                ('account', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
                ('health_record', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.health_record')),
                ('patient', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.patient')),
            ],
            options={
                'verbose_name': 'Prescription Record',
                'verbose_name_plural': 'Prescription Record',
            },
        ),
        migrations.CreateModel(
            name='Present_Illness',
            fields=[
                ('illnessNum', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('complaint', models.TextField(default=None)),
                ('findings', models.TextField(default=None)),
                ('diagnosis', models.TextField(default=None)),
                ('treatment', models.TextField(default=None)),
                ('patient', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.patient')),
            ],
        ),
    ]
