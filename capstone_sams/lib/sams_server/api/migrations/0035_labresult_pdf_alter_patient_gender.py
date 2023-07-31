# Generated by Django 4.2.3 on 2023-07-30 17:19

from django.db import migrations, models
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0034_labresult'),
    ]

    operations = [
        migrations.AddField(
            model_name='labresult',
            name='pdf',
            field=models.FileField(default=django.utils.timezone.now, upload_to='upload-pdf/'),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='patient',
            name='gender',
            field=models.CharField(choices=[('F', 'Female'), ('M', 'Male')]),
        ),
    ]
