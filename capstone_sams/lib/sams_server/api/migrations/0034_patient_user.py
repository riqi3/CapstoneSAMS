# Generated by Django 4.2.3 on 2023-08-10 07:52

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0033_alter_health_record_recordnum_alter_patient_gender'),
    ]

    operations = [
        migrations.AddField(
            model_name='patient',
            name='user',
            field=models.CharField(null=True),
        ),
    ]
