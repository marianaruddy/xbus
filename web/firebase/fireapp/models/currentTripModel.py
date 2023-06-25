from django.db import models
from ..models import CurrentTrip
from firebase_admin import firestore

db = firestore.client()

class CurrentTripModel(models.Model):

    #Create
    def createCurrentTrip(self, currentTrip, stop):
        currentTripDict = {
                'Order': stop.Order,
                'ActualTime': None,
                'PassengersQtyAfter': 0,
                'PassengersQtyBefore': 0,
                'PassengersQtyNew': 0,
                'IntendedTime': currentTrip.IntendedTime,
                'StopId': currentTrip.StopId,
                'TripId': currentTrip.TripId,
                'Active': True,
            }
        db.collection('CurrentTrip').add(currentTripDict)

    #Read
    def getCurrentTripsByTripId(self, tripId):
        currentTrips = db.collection('CurrentTrip').where('TripId','==',tripId).get()
        currentTripsList = []
        for t in currentTrips:
            tDict = t.to_dict()
            tDict["Id"] = t.id
            currentTripsList.append(tDict)

        return currentTripsList
    
    def getCurrentTripsById(self, id):
        currentTrip = db.collection('CurrentTrip').document(id).get()
        return currentTrip
    
    def getCurrentTripByTripIdAndStopId(self, tripId, stopId):
        currentTrips = db.collection('CurrentTrip').where('TripId','==',tripId).where('StopId','==',stopId).limit(1).get()
        if len(currentTrips) == 0:
            return None
        
        currentTrip = CurrentTrip()
        for t in currentTrips:
            tDict = t.to_dict()
            currentTrip.Id = t.id
            currentTrip.StopId = tDict['StopId']
            currentTrip.IntendedTime = tDict['IntendedTime']
            currentTrip.TripId = tDict['TripId']
            
            if 'ActualTime' in tDict:
                currentTrip.ActualTime = tDict['ActualTime']
            if 'PassengersQtyAfter' in tDict:
                currentTrip.PassengersQtyAfter = tDict['PassengersQtyAfter']
            if 'PassengersQtyBefore' in tDict:
                currentTrip.PassengersQtyBefore = tDict['PassengersQtyBefore']
            if 'PassengersQtyNew' in tDict:
                currentTrip.PassengersQtyNew = tDict['PassengersQtyNew']

        return currentTrip
    
    #Update
    def updateCurrentTrip(self, currentTrip):
        currentTrips = db.collection('CurrentTrip')
        currentTrips.document(currentTrip.Id).update(
            {
                'StopId': currentTrip.StopId,
                'IntendedTime': currentTrip.IntendedTime,
                'TripId': currentTrip.TripId,
            }
        )
    
    #Delete
    def deleteCurrentTripById(self, id):
        db.collection('CurrentTrip').document(id).update({'Active': False})