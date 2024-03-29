from django.db import models
from datetime import datetime

from .routeStopsModel import *
from .currentTrip import *
from .currentTripModel import *
from .trip import *
from .routeModel import *
from .ticket import *

from .stop import *

from firebase_admin import firestore

from django.conf import settings
import requests
import json

db = firestore.client()

class TripModel(models.Model):

    #Create
    def createTrip(self, trip):
        tripDict = {}
        update_time, trip_ref = db.collection('Trip').add(tripDict)
        tripId = trip_ref.id

        routeStopsModel = RouteStopsModel()
        stopsByRouteId = routeStopsModel.getStopsFromRouteId(trip.RouteId)

        if len(stopsByRouteId) > 0:
            lastTime = self.createPlannedCurrentTrips(tripId, stopsByRouteId, trip.IntendedDepartureTime)
            
            db.collection('Trip').document(tripId).set({
                'PassengersQty': 0,
                'TicketsQty': 0,
                'RouteId': trip.RouteId,
                'IntendedDepartureTime': trip.IntendedDepartureTime,
                'IntendedArrivalTime': lastTime,
                'CapacityInVehicle': trip.CapacityInVehicle,
                'Status': 'Future',
                'Active': True,
            })


    def createPlannedCurrentTrips(self, tripId, stopsByRouteId, intendedDepartureTime):
        #we are creating all the current trips related to that trip beforehand
        currentTripModel = CurrentTripModel()
        oldStop = stopsByRouteId[0]

        currentTime = intendedDepartureTime

        for stop in stopsByRouteId:
            currentTrip = CurrentTrip()
            currentTrip.StopId = stop.Id
            currentTrip.TripId = tripId
            if oldStop != stop:
                secondsToBeAdded = self.getTimeBetweenTwoStops(oldStop, stop)
                currentTime = currentTime + timedelta(seconds=secondsToBeAdded)
                currentTrip.IntendedTime = currentTime
            else:
                currentTrip.IntendedTime = intendedDepartureTime
            currentTripModel.createCurrentTrip(currentTrip, stop)
            oldStop = stop
        return currentTime

    def getTimeBetweenTwoStops(self, oldStop, stop):
        latOldStop = oldStop.Latitude
        longOldStop = oldStop.Longitude
        latStop = stop.Latitude
        longStop = stop.Longitude

        origin = f'{latOldStop},{longOldStop}'
        destination = f'{latStop},{longStop}'

        result = requests.get(
            'https://maps.googleapis.com/maps/api/directions/json?',
            params={
                'origin': origin,
                'destination': destination,
                "key": settings.GOOGLE_KEY
            }
        )

        timeInsSeconds = result.json()["routes"][0]["legs"][0]["duration"]["value"]
        return timeInsSeconds


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

            stopModel = StopModel()
            origin = stopModel.getStopById(route["Origin"])
            destiny = stopModel.getStopById(route["Destiny"])
            tDict["OriginName"] = origin.Name
            tDict["DestinyName"] = destiny.Name

            tripsList.append(tDict)

        return tripsList
    
    def getAllActiveTrips(self):
        trips = db.collection('Trip').where('Active','==',True).get()
        tripsList = []
        routeModel = RouteModel()
        for t in trips:
            tDict = t.to_dict()
            tDict["Id"] = t.id
            route = routeModel.getRouteById(tDict["RouteId"])
            tDict["Origin"] = route["Origin"]
            tDict["Destiny"] = route["Destiny"]

            stopModel = StopModel()
            origin = stopModel.getStopById(route["Origin"])
            destiny = stopModel.getStopById(route["Destiny"])
            tDict["OriginName"] = origin.Name
            tDict["DestinyName"] = destiny.Name

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
        tripModel.Status = tripDict['Status']
        return tripModel
    
    def hasTripAssociatedToRoute(self, routeId):
        tripsAssociatedToRoute = db.collection('Trip').where('RouteId','==',routeId).get()
        if len(tripsAssociatedToRoute) > 0:
            return True
        return False
    
    def getFutureOrProgressTripsByRouteId(self, routeId):
        tripsByRouteId = db.collection('Trip').where('RouteId','==',routeId)
        tripsFutureByRouteId = tripsByRouteId.where('Status','==','Future').get()
        tripsProgressByRouteId = tripsByRouteId.where('Status','==','Progress').get()
        tripsFutureOrProgressByRouteId = tripsFutureByRouteId + tripsProgressByRouteId
        return tripsFutureOrProgressByRouteId

    #Update
    def updateTrip(self, trip):
        trips = db.collection('Trip')
        

        currentTripModel = CurrentTripModel()
        existingCurrentTrips = currentTripModel.getCurrentTripsByTripId(trip.Id)
        existingTrip = self.getTripById(trip.Id)
        

        routeStopsModel = RouteStopsModel()
        stopsByRouteId = routeStopsModel.getStopsFromRouteId(existingTrip.RouteId)

        if len(stopsByRouteId) > 0:
            lastTime = self.updatePlannedCurrentTrips(trip.Id, stopsByRouteId, trip.IntendedDepartureTime)
            trips.document(trip.Id).update(
            {
                'IntendedDepartureTime': trip.IntendedDepartureTime,
                'CapacityInVehicle': trip.CapacityInVehicle,
                'IntendedArrivalTime': lastTime
            }
        )
        else:
            for currentTrip in existingCurrentTrips:
                currentTripModel.deleteCurrentTripById(currentTrip['Id'])

    def updatePlannedCurrentTrips(self, tripId, stopsByRouteId, intendedDepartureTime):
        #we are creating all the current trips related to that trip beforehand
        currentTripModel = CurrentTripModel()
        oldStop = stopsByRouteId[0]
        currentTime = intendedDepartureTime

        for stop in stopsByRouteId:
            currentTrip = CurrentTrip()
            currentTrip.StopId = stop.Id
            currentTrip.TripId = tripId
            if oldStop != stop:
                secondsToBeAdded = self.getTimeBetweenTwoStops(oldStop, stop)
                currentTime = currentTime + timedelta(seconds=secondsToBeAdded)
                currentTrip.IntendedTime = currentTime
            else:
                currentTrip.IntendedTime = intendedDepartureTime

            existingCurrentTrip = currentTripModel.getCurrentTripByTripIdAndStopId(tripId,stop.Id)
            if existingCurrentTrip == None:
                currentTripModel.createCurrentTrip(currentTrip)
            else:
                existingCurrentTrip.StopId = currentTrip.StopId
                existingCurrentTrip.TripId = currentTrip.TripId
                existingCurrentTrip.IntendedTime = currentTrip.IntendedTime

                currentTripModel.updateCurrentTrip(existingCurrentTrip)
            oldStop = stop
        return currentTime
    
    def cancelTrip(self, id):
        db.collection('Trip').document(id).update({'Status': 'Interrupted'})

        self.chargeback(id)



    #Delete
    def deleteTripById(self, id):
        db.collection('Trip').document(id).update({'Active': False})
        self.chargeback(id)
        currentTripModel = CurrentTripModel()
        currentTrips = currentTripModel.getCurrentTripsByTripId(id)
        for currentTrip in currentTrips:
            currentTripModel.deleteCurrentTripById(currentTrip['Id'])

    #Aux
    def chargeback(self, id):
        ticketModel = Ticket()
        tickets = ticketModel.getNotUsedTicketsByTripId(id)
        for ticket in tickets:
            ticketDict = ticket.to_dict()
            currentTripModel = CurrentTripModel()
            ticketModel.deactivateTicket(ticket.id)
            intendedTime = currentTripModel.getCurrentTripsById(ticketDict['CurrentTripId']).to_dict()['IntendedTime']
            passenger = ticketModel.getPassengerByPassengerId(ticketDict['PassengerId'])
            date = datetime.now()
            description = "Estorno da viagem planejada para " + intendedTime
            transaction = {
                'Date': date,
                'Description': description,
                'Value': ticketDict['Price'],
            }
            passenger.collection('Transaction').add(transaction)