from django.db import models

class CurrentTrip(models.Model):
    Id = models.CharField(max_length=200)
    ActualTime = models.DateTimeField()
    IntendedTime = models.DateTimeField()
    PassengersQtyAfter = models.IntegerField()
    PassengersQtyBefore = models.IntegerField()
    PassengersQtyNew = models.IntegerField()
    StopId = models.CharField(max_length=200)
    TripId = models.CharField(max_length=200)