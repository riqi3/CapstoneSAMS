# Generated by Django 4.2.3 on 2023-11-02 13:52

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('user', '0006_account_profile_photo'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='account',
            options={'verbose_name': 'Account Record', 'verbose_name_plural': 'Account Record'},
        ),
        migrations.AlterModelOptions(
            name='data_log',
            options={'verbose_name': 'Data Logs', 'verbose_name_plural': 'Data Logs'},
        ),
    ]
