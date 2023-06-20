from django.db import models

class Vehicle(models.Model):
    Id = models.CharField(max_length=200)
    LicensePlate = models.CharField(max_length=200)
    Capacity = models.IntegerField()