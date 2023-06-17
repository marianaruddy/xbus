from django.db import models

class Route(models.Model):
    Id = models.CharField(max_length=200)
    Destiny = models.CharField(max_length=100)
    Origin = models.CharField(max_length=100)
    DestinyName = models.CharField(max_length=100)
    OriginName = models.CharField(max_length=100)
    Number = models.IntegerField()