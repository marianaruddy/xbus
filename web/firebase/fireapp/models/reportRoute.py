from django.db import models

class ReportRoute(models.Model):
    NumberOfPassengers = models.IntegerField()
    StopWithMostPassengers = models.CharField(max_length=200)
    NumberOfPassengersInStopWithMostPassengers = models.IntegerField()
    StopWithBiggestWaitingTime = models.CharField(max_length=200)
    BiggestWaitingTimeInAStop = models.TimeField()
    StopWithShortestWaitingTime = models.CharField(max_length=200)
    ShortestWaitingTimeInAStop = models.TimeField()
    AverageWaitingTime = models.TimeField()
    RouteId = models.CharField(max_length=200)
    Date = models.DateField()