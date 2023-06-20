from django.db import models

class Driver(models.Model):
    Id = models.CharField(max_length=200)
    Name = models.CharField(max_length=200)
    Company = models.CharField(max_length=200)
    Document = models.CharField(max_length=200)
    Email = models.EmailField()

    def info(self):
        return f"Driver Id: {self.Id}, Name: {self.Name}, Company: {self.Company}, Document: {self.Document}, Email: {self.Email}"