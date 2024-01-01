from django.db import models

class DiagnosticFields(models.Model):
    disease = models.CharField(max_length=255)
    fever = models.CharField(max_length=3, choices=[('Yes', 'Yes'), ('No', 'No')])
    cough = models.CharField(max_length=3, choices=[('Yes', 'Yes'), ('No', 'No')])
    fatigue = models.CharField(max_length=3, choices=[('Yes', 'Yes'), ('No', 'No')])
    difficulty_breathing = models.CharField(max_length=3, choices=[('Yes', 'Yes'), ('No', 'No')])
    age = models.IntegerField()
    gender = models.CharField(max_length=10, choices=[('Male', 'Male'), ('Female', 'Female')])
    blood_pressure = models.CharField(max_length=10, choices=[('Low', 'Low'), ('Normal', 'Normal'), ('High', 'High')])
    cholesterol_level = models.CharField(max_length=10, choices=[('Low', 'Low'), ('Normal', 'Normal'), ('High', 'High')])
    outcome_variable = models.CharField(max_length=10, choices=[('Positive', 'Positive'), ('Negative', 'Negative')])

    def __str__(self):
        return f"{self.disease} - {self.gender} - {self.age}"

    class Meta:
        verbose_name = "Diagnostic Dataset"
        verbose_name_plural = "Diagnostic Dataset"