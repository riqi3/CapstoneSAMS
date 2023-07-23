from django.db import models
from django import forms

class Mims(models.Model):
    bnf = models.CharField( max_length=20)
    description = models.CharField( max_length=128)
    
    class Meta:
        ordering = ["bnf"]

    def __str__(self):
        return f"{self.bnf}"

 