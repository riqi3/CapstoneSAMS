from django.db import models
 
'''
This model represent the patients
inputted and stored into the system.
'''
class Patient(models.Model):

    GENDER_OPTIONS = {
        ('M', 'Male'),
        ('F', 'Female')
    }

    #Patient Indentification
    patientID = models.CharField(max_length=100, primary_key=True)
    firstName = models.CharField(max_length=100, blank = False)
    middleName = models.CharField(max_length=100, blank = True)
    lastName = models.CharField(max_length=100, blank = False)
    age = models.IntegerField(blank= False)
    gender = models.CharField(choices = GENDER_OPTIONS)
    birthDate = models.DateField(blank = False)
    registration = models.DateField(blank=False)
    phone = models.CharField(max_length = 20, blank = True)
    email = models.CharField(max_length = 50, blank = True)
    user = models.CharField(null = True, blank = True)

    
    def __str__(self):
        return f"{self.patientID} - {self.firstName} {self.middleName} {self.lastName}"
    
    class Meta:
        verbose_name = "Patient Record"
        verbose_name_plural = "Patient Record"

'''
This model represent the health records
inputted and stored into the system. Each
record is connected to only one patient.
'''
class Health_Record(models.Model):
    #Health Record Attributes
    recordNum = models.AutoField(primary_key = True)
    symptoms = models.JSONField(blank = True, default=None)
    diseases = models.JSONField(blank = True, default=None)
    patient = models.ForeignKey(Patient, on_delete = models.CASCADE)

    class Meta:
        verbose_name = "Health Record"
        verbose_name_plural = "Health Record"
