from django.db import models

class Region(models.Model):
    Id = models.CharField(max_length=200)
    Name = models.CharField(max_length=100)