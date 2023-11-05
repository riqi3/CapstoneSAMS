# Generated by Django 4.2.3 on 2023-11-05 15:20

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='health_record',
            options={'verbose_name': 'Health Record', 'verbose_name_plural': 'Health Record'},
        ),
        migrations.AlterModelOptions(
            name='healthsymptom',
            options={'verbose_name': 'Symptom Dataset', 'verbose_name_plural': 'Symptom Dataset'},
        ),
        migrations.AlterModelOptions(
            name='labresult',
            options={'verbose_name': 'Laboratory Record', 'verbose_name_plural': 'Laboratory Record'},
        ),
        migrations.AlterModelOptions(
            name='medicine',
            options={'verbose_name': 'Medicine Record', 'verbose_name_plural': 'Medicine Record'},
        ),
        migrations.AlterModelOptions(
            name='patient',
            options={'verbose_name': 'Patient Record', 'verbose_name_plural': 'Patient Record'},
        ),
        migrations.AlterModelOptions(
            name='prescription',
            options={'verbose_name': 'Prescription Record', 'verbose_name_plural': 'Prescription Record'},
        ),
        migrations.AlterField(
            model_name='patient',
            name='gender',
            field=models.CharField(choices=[('M', 'Male'), ('F', 'Female')]),
        ),
    ]
