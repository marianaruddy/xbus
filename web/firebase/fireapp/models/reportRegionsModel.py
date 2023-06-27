from django.db import models
from datetime import timedelta

from .reportRoute import *
from .stopModel import *

from firebase_admin import firestore

db = firestore.client()

class ReportRegionsModel(models.Model):

    def getQuantityOfTicketsGeneratedByRouteDateAndRegion(self, routeId, startDate, endDate, regionId):
        trips1 = db.collection('Trip').where("RouteId","==",routeId).where("ActualDepartureTime",">=",startDate).where("ActualDepartureTime","<",endDate).get()
        trips2 = db.collection('Trip').where("RouteId","==",routeId).where("ActualArrivalTime",">=",startDate).where("ActualArrivalTime","<",endDate).get()
        trips = trips1 +trips2
        if not trips:
            return 0
        
        stopModel = StopModel()
        stopsByRegion = stopModel.getStopsDictByRegionId(regionId)
        stopIds = []
        for stop in stopsByRegion:
            stopIds.append(stop['Id'])

        if not stopIds:
            return 0
        
        currentTripIds = []
        for trip in trips:
            currentTrips = db.collection('CurrentTrip').where("TripId","==",trip.id).where('StopId','in',stopIds).get()
            if not currentTrips:
                continue
            for currentTrip in currentTrips:
                currentTripIds.append(currentTrip.id)

        if not currentTripIds:
            return 0
            
        tickets = db.collection('Ticket').where("CurrentTripId","in",currentTripIds).where("Checked", "==", True).where("Active", "==", True).where("Used", "==", True).get()
        ticketsList = []
        for t in tickets:
            ticketsList.append(t.to_dict())

        return len(ticketsList)