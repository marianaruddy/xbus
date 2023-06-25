from django.db import models

class Stop(models.Model):
    Id = models.CharField(max_length=200)
    Address = models.CharField(max_length=200)
    Name = models.CharField(max_length=100)
    RegionId = models.CharField(max_length=100)
    Longitude = models.DecimalField(max_digits=9, decimal_places=6)
    Latitude = models.DecimalField(max_digits=9, decimal_places=6)
    Order = models.IntegerField()


    def info(self):
        return f"Stop Id: {self.Id}, Name: {self.Name}, Address: {self.Address}, RegionId: {self.RegionId}"