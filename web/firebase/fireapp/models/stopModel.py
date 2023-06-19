from django.db import models

from .stop import *

from firebase_admin import firestore
from google.cloud.firestore import GeoPoint
from datetime import datetime, timedelta

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
                'Coords': location,
                'Active': True
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
    
    def getStopsDictByRegionId(self, regionId):
        stops = db.collection('Stop').where('RegionId','==',regionId).get()
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
    
    def getStopDictNoCoordsById(self, id):
        stop = db.collection('Stop').document(id).get()
        stopDict = stop.to_dict()
        stopDict["Id"] = id
        stopDict["Coords"] = ""

        return stopDict
    
    def getStopDictByName(self, name):
        stops = db.collection('Stop').where('Name','==',name).get()
        stopDict = {}
        if len(stops) > 0:
            stop = stops[0]
            stopDict = stop.to_dict()
            stopDict["Id"] = stop.id
        return stopDict
    
    def getQuantityOfTicketsGeneratedToStopToTheNext30Minutes(self,stopId):
        now = datetime.now()
        next30Minutes = now + timedelta(minutes=30)
        currentTripsByStopAndDate = db.collection('CurrentTrip').where("StopId","==",stopId).where("IntentedTime",">=",now).where("IntentedTime","<",next30Minutes).get()
        currentTripIds = []
        for ct in currentTripsByStopAndDate:
            currentTripIds.append(ct.id)
        tickets = []
        if len(currentTripIds) > 0:
            tickets = db.collection('Ticket').where("CurrentTripId","in",currentTripIds).where('Checked','==',False).get()
        ticketsList = []
        for t in tickets:
            tDict = t.to_dict()
            ticketsList.append(tDict)

        return len(ticketsList)
    
    #Update
    def updateStop(self, stop):
        print(stop.info())
        stops = db.collection('Stop')
        stops.document(stop.Id).update(
            {
                'Name': stop.Name,
                'Address': stop.Address,
                'RegionId': stop.RegionId,
            }
        )
    
    #Delete
    def deleteStopById(self, id):
        db.collection('Stop').document(id).delete()