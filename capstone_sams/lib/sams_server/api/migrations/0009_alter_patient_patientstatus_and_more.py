# Generated by Django 5.0.1 on 2024-02-04 16:41

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0008_alter_patient_patientstatus_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='patient',
            name='patientStatus',
            field=models.CharField(choices=[('Widowed', 'Widowed'), ('Divorced', 'Divorced'), ('Single', 'Single'), ('Married', 'Married'), ('Separated', 'Separated')]),
        ),
        migrations.AlterField(
            model_name='present_illness',
            name='created_at',
            field=models.DateTimeField(auto_now_add=True),
        ),
        migrations.AlterField(
            model_name='present_illness',
            name='updated_at',
            field=models.DateTimeField(auto_now=True),
        ),
    ]
