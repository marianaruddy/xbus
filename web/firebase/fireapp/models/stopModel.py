from django.db import models

from .stop import *

from firebase_admin import firestore
from google.cloud.firestore import GeoPoint

db = firestore.client()

class StopModel(models.Model):

    def __init__(self):
        return
    
    #Create
    def createStop(self, stop):
        location = GeoPoint(stop.Latitude, stop.Longitude)
        stopDict = {
                'Address': stop.Address,
                'Name': stop.Name,
                'RegionId': stop.RegionId,
                'Coords': location
            }
        db.collection('Stop').add(stopDict)
    
    #Read
    def getAllStops(self):
        stops = db.collection('Stop').get()
        stopsList = []
        for s in stops:
            sDict = s.to_dict()
            sDict["Id"] = s.id
            sDict["Latitude"] = sDict["Coords"].latitude
            sDict["Longitude"] = sDict["Coords"].longitude
            del sDict["Coords"]
            stopsList.append(sDict)

        return stopsList
    
    def getStopById(self, id):
        stop = db.collection('Stop').document(id).get()
        stopDict = stop.to_dict()
        stopModel = Stop()
        stopModel.Id = id
        stopModel.Address = stopDict["Address"]
        stopModel.Name = stopDict["Name"]
        stopModel.RegionId = stopDict["RegionId"]
        stopModel.Latitude = stopDict["Coords"].latitude
        stopModel.Longitude = stopDict["Coords"].longitude

        return stopModel
    
    #Update
    def updateStop(self, stop):
        print(stop.info())
        stops = db.collection('Stop')
        stops.document(stop.Id).set(
            {
                'Name': stop.Name,
                'Address': stop.Address,
                'RegionId': stop.RegionId,
            }
        )
    
    #Delete
    def deleteStopById(self, id):
        db.collection('Stop').document(id).delete()