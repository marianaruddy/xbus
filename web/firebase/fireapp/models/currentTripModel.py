from django.db import models
from firebase_admin import firestore

db = firestore.client()

class CurrentTripModel(models.Model):

    #Create
    def createCurrentTrip(self, currentTrip):
        currentTripDict = {
                'IntendedTime': currentTrip.IntendedTime,
                'StopId': currentTrip.StopId,
                'TripId': currentTrip.TripId
            }
        db.collection('CurrentTrip').add(currentTripDict)