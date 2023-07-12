# Generated by Django 4.2.3 on 2023-07-12 06:54

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0003_rename_data_logs_data_log_and_more'),
    ]

    operations = [
        migrations.CreateModel(
            name='CSVDrug',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=128)),
                ('description', models.TextField(max_length=512)),
                ('csv', models.FileField(upload_to='upload/')),
            ],
            options={
                'ordering': ['title'],
            },
        ),
        migrations.CreateModel(
            name='DrugModel',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('drugID', models.CharField(max_length=100)),
                ('bnf', models.CharField(max_length=20)),
                ('description', models.CharField(max_length=128)),
            ],
            options={
                'ordering': ['drugID'],
            },
        ),
    ]
