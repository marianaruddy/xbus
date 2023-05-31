from django.db import models

class Trip(models.Model):
    Id = models.CharField(max_length=200)
    ActualArrivalTime = models.DateTimeField()
    ActualDepartureTime = models.DateTimeField()
    DriverId = models.CharField(max_length=200)
    IntendedArrivalTime = models.DateTimeField()
    IntendedDepartureTime = models.DateTimeField()
    PassengersQty = models.IntegerField()
    RouteId = models.CharField(max_length=200)
    VehicleId = models.CharField(max_length=200)
    CapacityInVehicle = models.IntegerField()