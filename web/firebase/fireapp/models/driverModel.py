from django.db import models

from .driver import *

from firebase_admin import firestore

db = firestore.client()

class DriverModel(models.Model):

    #Create
    def createDriver(self, driver):
        driverDict = {
                'Name': driver.Name,
                'Company': driver.Company,
                'Document': driver.Document,
                'Email': driver.Email
            }
        db.collection('Driver').add(driverDict)

    #Read
    def getAllDrivers(self):
        drivers = db.collection('Driver').get()
        driversList = []
        for d in drivers:
            dDict = d.to_dict()
            dDict["Id"] = d.id
            driversList.append(dDict)

        return driversList
    
    def getDriverById(self, id):
        driver = db.collection('Driver').document(id).get()
        driverDict = driver.to_dict()
        driverModel = Driver()
        driverModel.Id = id
        driverModel.Name = driverDict["Name"]
        driverModel.Company = driverDict["Company"]
        driverModel.Document = driverDict["Document"]
        driverModel.Email = driverDict["Email"]
        return driverModel

    #Update
    def updateDriver(self, driver):
        drivers = db.collection('Driver')
        drivers.document(driver.Id).set(
            {
                'Company': driver.Company,
                'Document': driver.Document,
                'Name': driver.Name,
                'Email': driver.Email,
            }
        )

    #Delete
    def deleteDriverById(self, id):
        db.collection('Driver').document(id).delete()