import datetime
from django.db import models
from datetime import timedelta

from .reportRoute import *

from firebase_admin import firestore

db = firestore.client()

class ReportRouteModel(models.Model):

    def getReportRoute(self, routeId, date):
        reportRoute = ReportRoute()
        reportRoute.NumberOfPassengers = self.getNumberOfPassengersByRouteAndDate(routeId,date)
        reportRoute.StopWithMostPassengers = self.getStopWithMostPassengersByRouteAndDate(routeId,date)
        reportRoute.NumberOfPassengersInStopWithMostPassengers = self.getNumberOfPassengersInStopWithMostPassengersByRouteAndDate(routeId,date)
        reportRoute.StopWithBiggestWaitingTime = self.getStopWithBiggestWaitingTimeByRouteAndDate(routeId,date)
        reportRoute.BiggestWaitingTimeInAStop = self.getBiggestWaitingTimeInAStopByRouteAndDate(routeId,date)
        reportRoute.StopWithShortestWaitingTime = self.getStopWithShortestWaitingTimeByRouteAndDate(routeId,date)
        reportRoute.ShortestWaitingTimeInAStop = self.getShortestWaitingTimeInAStopByRouteAndDate(routeId,date)
        reportRoute.AverageWaitingTime = self.getAverageWaitingTimeByRouteAndDate(routeId,date)
        return reportRoute


    def getNumberOfPassengersByRouteAndDate(self, route, date):
        nextDay = date + timedelta(days=1)
        tripsThatHappened = db.collection('Trip').where("RouteId","==",route).order_by("ActualDepartureTime")
        tripsThatHappened = tripsThatHappened.where("ActualDepartureTime",">=",date).where("ActualDepartureTime","<",nextDay).get()
        numberOfPassengers = 0
        if not tripsThatHappened:
            return 0
        
        for t in tripsThatHappened:
            currentTrips = db.collection('CurrentTrip').where('TripId','==',t.id).get()
            if not currentTrips:
                continue

            for ct in currentTrips:
                ctDict = ct.to_dict()
                if "PassengersQtyNew" not in ctDict:
                    continue
                numberOfPassengers = numberOfPassengers + ctDict["PassengersQtyNew"]
            
        return numberOfPassengers


    def getStopWithMostPassengersByRouteAndDate(self, route,date):
        nextDay = date + timedelta(days=1)
        stopsByRoute = db.collection('RouteStops').where("RouteId","==",route).get()
        numberOfPassengersByStop = {}
        for stopRoute in stopsByRoute:
            currentTripsByStopAndDate = db.collection('CurrentTrip').where("StopId","==",stopRoute.id).where("ActualTime",">=",date).where("ActualTime","<",nextDay).get()
            currentTripIds = []
            for ct in currentTripsByStopAndDate:
                currentTripIds.append(ct.id)

            numberOfPassengers = 0
            if len(currentTripIds) > 0:
                numberOfPassengers = len(db.collection('Tickets').where("CurrentTripId","in",currentTripIds).where("Checked", "==", True).where("Active", "==", True).where("Used", "==", True).get())
            
            stopRouteDict = stopRoute.to_dict()
            stop = db.collection('Stop').document(stopRouteDict["StopId"]).get()
            stopDict = stop.to_dict()

            numberOfPassengersByStop[stopDict["Name"]] = numberOfPassengers
        
        return max(numberOfPassengersByStop.values(), default="None")

    def getNumberOfPassengersInStopWithMostPassengersByRouteAndDate(self, route, date):
        nextDay = date + timedelta(days=1)
        stopsByRoute = db.collection('RouteStops').where("RouteId","==",route).get()
        numberOfPassengersByStop = {}
        for stopRoute in stopsByRoute:
            stopRouteDict = stopRoute.to_dict()
            currentTripsByStopAndDate = db.collection('CurrentTrip').where("StopId","==",stopRouteDict["StopId"]).where("ActualTime",">=",date).where("ActualTime","<",nextDay).get()
            currentTripIds = []
            for ct in currentTripsByStopAndDate:
                currentTripIds.append(ct.id)

            numberOfPassengers = 0
            if len(currentTripIds) > 0:
                numberOfPassengers = len(db.collection('Tickets').where("CurrentTripId","in",currentTripIds).where("Checked", "==", True).where("Active", "==", True).where("Used", "==", True).get())
            
            stopRouteDict = stopRoute.to_dict()
            stop = db.collection('Stop').document(stopRouteDict["StopId"]).get()
            stopDict = stop.to_dict()

            numberOfPassengersByStop[stopDict["Name"]] = numberOfPassengers
        
        return max(numberOfPassengersByStop.values(), default=0)

    def getStopWithBiggestWaitingTimeByRouteAndDate(self, route, date):
        nextDay = date + timedelta(days=1)
        stopsByRoute = db.collection('RouteStops').where("RouteId","==",route).get()
        timesByStop = {}

        for stopRoute in stopsByRoute:
            stopRouteDict = stopRoute.to_dict()
            currentTrips = db.collection('CurrentTrip').where("StopId","==",stopRouteDict["StopId"]).where("IntendedTime",">=",date).where("IntendedTime","<",nextDay).get()

            for currentTrip in currentTrips:
                currentTripDict = currentTrip.to_dict()
                if 'ActualTime' not in currentTripDict or currentTripDict["ActualTime"] == None:
                    continue
                timeSpan = currentTripDict["ActualTime"] - currentTripDict["IntendedTime"]

                stop = db.collection('Stop').document(stopRouteDict["StopId"]).get()
                stopDict = stop.to_dict()
                
                if stopDict["Name"] not in timesByStop.keys() or timesByStop[stopDict["Name"]] < timeSpan:
                    timesByStop[stopDict["Name"]] = timeSpan

        return max(timesByStop, key=timesByStop.get, default="None")


    def getBiggestWaitingTimeInAStopByRouteAndDate(self, route, date):
        nextDay = date + timedelta(days=1)
        stopsByRoute = db.collection('RouteStops').where("RouteId","==",route).get()
        timesByStop = {}
        for stopRoute in stopsByRoute:
            stopRouteDict = stopRoute.to_dict()
            currentTrips = db.collection('CurrentTrip').where("StopId","==",stopRouteDict["StopId"]).where("IntendedTime",">=",date).where("IntendedTime","<",nextDay).get()
            
            for currentTrip in currentTrips:
                currentTripDict = currentTrip.to_dict()
                if 'ActualTime' not in currentTripDict or currentTripDict["ActualTime"] == None:
                    continue
                timeSpan = currentTripDict["ActualTime"] - currentTripDict["IntendedTime"]

                stop = db.collection('Stop').document(stopRouteDict["StopId"]).get()
                stopDict = stop.to_dict()

                if stopDict["Name"] not in timesByStop.keys() or timesByStop[stopDict["Name"]] < timeSpan:
                    timesByStop[stopDict["Name"]] = timeSpan

        return max(timesByStop.values(), default="None")

    def getStopWithShortestWaitingTimeByRouteAndDate(self, route, date):
        nextDay = date + timedelta(days=1)
        stopsByRoute = db.collection('RouteStops').where("RouteId","==",route).get()
        timesByStop = {}
        for stopRoute in stopsByRoute:
            stopRouteDict = stopRoute.to_dict()
            currentTrips = db.collection('CurrentTrip').where("StopId","==",stopRouteDict["StopId"]).where("IntendedTime",">=",date).where("IntendedTime","<",nextDay).get()
            for currentTrip in currentTrips:
                currentTripDict = currentTrip.to_dict()
                if 'ActualTime' not in currentTripDict or currentTripDict["ActualTime"] == None:
                    continue
                timeSpan = currentTripDict["ActualTime"] - currentTripDict["IntendedTime"]

                stop = db.collection('Stop').document(stopRouteDict["StopId"]).get()
                stopDict = stop.to_dict()

                if stopDict["Name"] not in timesByStop.keys() or timesByStop[stopDict["Name"]] > timeSpan:
                    timesByStop[stopDict["Name"]] = timeSpan

        return max(timesByStop, key=timesByStop.get, default="None")

    def getShortestWaitingTimeInAStopByRouteAndDate(self, route, date):
        nextDay = date + timedelta(days=1)
        stopsByRoute = db.collection('RouteStops').where("RouteId","==",route).get()
        timesByStop = {}
        for stopRoute in stopsByRoute:
            stopRouteDict = stopRoute.to_dict()
            currentTrips = db.collection('CurrentTrip').where("StopId","==",stopRouteDict["StopId"]).where("IntendedTime",">=",date).where("IntendedTime","<",nextDay).get()
            for currentTrip in currentTrips:
                currentTripDict = currentTrip.to_dict()
                if 'ActualTime' not in currentTripDict or currentTripDict["ActualTime"] == None:
                    continue
                timeSpan = currentTripDict["ActualTime"] - currentTripDict["IntendedTime"]

                stop = db.collection('Stop').document(stopRouteDict["StopId"]).get()
                stopDict = stop.to_dict()

                if stopDict["Name"] not in timesByStop.keys() or timesByStop[stopDict["Name"]] > timeSpan:
                    timesByStop[stopDict["Name"]] = timeSpan

        return max(timesByStop.values(), default="None")

    def getAverageWaitingTimeByRouteAndDate(self, route, date):
        nextDay = date + timedelta(days=1)
        tripsThatHappened = db.collection('Trip').where("RouteId","==",route).order_by("ActualDepartureTime")
        tripsThatHappened = tripsThatHappened.where("ActualDepartureTime",">=",date).where("ActualDepartureTime","<",nextDay).get()

        timesByTrip = 0
        countTrip = 0

        for trip in tripsThatHappened:
            currentTrips = db.collection('CurrentTrip').where("TripId","==",trip.id).where('Active','==',True).get()

            count = 0

            for currentTrip in currentTrips:
                currentTripDict = currentTrip.to_dict()
                if 'ActualTime' not in currentTripDict or currentTripDict["ActualTime"] == None:
                    continue
                timeSpan = currentTripDict["ActualTime"] - currentTripDict["IntendedTime"]

                if count == 0:
                    sumTimeSpan = timeSpan
                else:
                    sumTimeSpan = sumTimeSpan + timeSpan
                count = count + 1

            if count == 0:
                continue
            meanByTrip = (sumTimeSpan/count)
            
            if countTrip == 0:
                timesByTrip = meanByTrip
            else:
                timesByTrip = timesByTrip + meanByTrip
            countTrip = countTrip + 1

        if countTrip > 0:
            return timesByTrip/countTrip
        else:
            return "None"