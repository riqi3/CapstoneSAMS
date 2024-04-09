# Generated by Django 4.2.3 on 2024-04-09 14:56

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0003_alter_patient_department_alter_patient_patientstatus'),
    ]

    operations = [
        migrations.AlterField(
            model_name='patient',
            name='department',
            field=models.CharField(choices=[('SOE', 'SOE'), ('Kindergarten', 'Kindergarten'), ('SCS', 'SCS'), ('Senior High School', 'Senior High School'), ('SAMS', 'SAMS'), ('Junior High School', 'Junior High School'), ('SBM', 'SBM'), ('SAS', 'SAS'), ('Nursery', 'Nursery'), ('SED', 'SED'), ('SOL', 'SOL')]),
        ),
        migrations.AlterField(
            model_name='patient',
            name='gender',
            field=models.CharField(choices=[('F', 'Female'), ('M', 'Male')]),
        ),
        migrations.AlterField(
            model_name='patient',
            name='patientStatus',
            field=models.CharField(choices=[('Single', 'Single'), ('Widowed', 'Widowed'), ('Separated', 'Separated'), ('Divorced', 'Divorced'), ('Married', 'Married')]),
        ),
    ]
