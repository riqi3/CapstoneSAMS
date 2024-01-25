# Generated by Django 5.0.1 on 2024-01-25 16:42

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_present_illness_created_at_and_more'),
    ]

    operations = [
        migrations.RenameField(
            model_name='contact_person',
            old_name='contactId',
            new_name='contactID',
        ),
        migrations.RenameField(
            model_name='medical_record',
            old_name='recordNum',
            new_name='recordID',
        ),
        migrations.RenameField(
            model_name='present_illness',
            old_name='illnessNum',
            new_name='illnessID',
        ),
        migrations.AlterField(
            model_name='patient',
            name='patientStatus',
            field=models.CharField(choices=[('Separated', 'Separated'), ('Divorced', 'Divorced'), ('Married', 'Married'), ('Widowed', 'Widowed'), ('Single', 'Single')]),
        ),
    ]
