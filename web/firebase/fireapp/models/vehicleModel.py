from django.db import models

from .vehicle import *

from firebase_admin import firestore

db = firestore.client()

class VehicleModel(models.Model):

    #Create
    def createVehicle(self, vehicle):
        vehicleDict = {
                'Name': vehicle.Name,
                'Capacity': vehicle.Capacity,
                'LicensePlate': vehicle.LicensePlate
            }
        db.collection('Vehicle').add(vehicleDict)

    #Read
    def getAllVehicles(self):
        vehicles = db.collection('Vehicle').get()
        vehiclesList = []
        for v in vehicles:
            vDict = v.to_dict()
            vDict["Id"] = v.id
            vehiclesList.append(vDict)

        return vehiclesList
    
    def getVehicleById(self, id):
        vehicle = db.collection('Vehicle').document(id).get()
        vehicleDict = vehicle.to_dict()
        vehicleModel = Vehicle()
        vehicleModel.Id = id
        vehicleModel.Name = vehicleDict["Name"]
        vehicleModel.LicensePlate = vehicleDict["LicensePlate"]
        vehicleModel.Capacity = vehicleDict["Capacity"]
        return vehicleModel

    #Update
    def updateVehicle(self, vehicle):
        vehicles = db.collection('Vehicle')
        vehicles.document(vehicle.Id).set(
            {
                'Name': vehicle.Name,
                'LicensePlate': vehicle.LicensePlate,
                'Capacity': vehicle.Capacity,
            }
        )

    #Delete
    def deleteVehicleById(self, id):
        db.collection('Vehicle').document(id).delete()