from django.db import models
from datetime import datetime

from .routeStopsModel import *
from .currentTrip import *
from .currentTripModel import *
from .trip import *
from .routeModel import *

from firebase_admin import firestore

db = firestore.client()

class TripModel(models.Model):

    #Create
    def createTrip(self, trip):
        print("trip.RouteId")
        tripDict = {
                'RouteId': trip.RouteId,
                'IntendedDepartureTime': trip.IntendedDepartureTime,
                'IntendedArrivalTime': trip.IntendedArrivalTime,
                'CapacityInVehicle': trip.CapacityInVehicle
            }
        update_time, trip_ref = db.collection('Trip').add(tripDict)
        tripId = trip_ref.id

        routeStopsModel = RouteStopsModel()
        stopsByRouteId = routeStopsModel.getStopsFromRouteId(trip.RouteId)

        #we are creating all the current trips related to that trip beforehand
        currentTripModel = CurrentTripModel()
        for stopId in stopsByRouteId:
            currentTrip = CurrentTrip()
            currentTrip.StopId = stopId
            currentTrip.TripId = tripId
            currentTrip.IntendedTime = datetime.now() #this is temporary, it needs to be changed to the time difference between two stops(api google)
            currentTripModel.createCurrentTrip(currentTrip)


    #Read
    def getAllTrips(self):
        trips = db.collection('Trip').get()
        tripsList = []
        routeModel = RouteModel()
        for t in trips:
            tDict = t.to_dict()
            tDict["Id"] = t.id
            route = routeModel.getRouteById(tDict["RouteId"])
            tDict["Origin"] = route["Origin"]
            tDict["Destiny"] = route["Destiny"]
            tripsList.append(tDict)

        return tripsList
    
    def getTripById(self, id):
        trip = db.collection('Trip').document(id).get()
        tripDict = trip.to_dict()
        tripModel = Trip()
        tripModel.Id = id
        tripModel.RouteId = tripDict["RouteId"]
        tripModel.IntendedDepartureTime = tripDict["IntendedDepartureTime"]
        tripModel.IntendedArrivalTime = tripDict["IntendedArrivalTime"]
        tripModel.CapacityInVehicle = tripDict["CapacityInVehicle"]
        return tripModel

    #Update
    def updateTrip(self, trip):
        trips = db.collection('Trip')
        trips.document(trip.Id).set(
            {
                'RouteId': trip.RouteId,
                'IntendedDepartureTime': trip.IntendedDepartureTime,
                'IntendedArrivalTime': trip.IntendedArrivalTime,
                'CapacityInVehicle': trip.CapacityInVehicle,
            }
        )

        self.updateCurrentTrips()
    
    def updateCurrentTrips(self):
        pass

    #Delete
    def deleteTripById(self, id):
        db.collection('Trip').document(id).delete()