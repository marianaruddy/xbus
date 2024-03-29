from django.db import models
from datetime import timedelta

from .route import *
from .stopModel import *
from .routeStopsModel import*

from firebase_admin import firestore

db = firestore.client()

class RouteModel(models.Model):

    def __init__(self):
        return
    
    #Create
    def createRoute(self, route):
        lastRoutes = db.collection('Route').order_by('Number', direction=firestore.Query.DESCENDING).limit(1).get()
        number = 1
        if len(lastRoutes) > 0:
            lastRoute = lastRoutes[0]
            lastRouteDict = lastRoute.to_dict()
            lastNumber = lastRouteDict['Number']
            number = lastNumber + 1

        routeDict = {
                'Destiny': route.Destiny,
                'Origin': route.Origin,
                'Number': number,
                'Price': route.Price,
                'Active': True
            }
        update_time, route_ref = db.collection('Route').add(routeDict)
        return route_ref.id
    
    #Read
    def getAllRoutes(self):
        routes = db.collection('Route').get()
        routesList = []
        for r in routes:
            rDict = r.to_dict()
            route = Route()
            route.Id = r.id
            route.Destiny = rDict["Destiny"]
            route.Origin = rDict["Origin"]
            route.Number = rDict["Number"]

            stopModel = StopModel()
            destiny = stopModel.getStopById(rDict["Destiny"])
            origin = stopModel.getStopById(rDict["Origin"])
            route.DestinyName = destiny.Name
            route.OriginName = origin.Name

            routesList.append(route)

        return routesList
    
    def getAllActiveRoutes(self):
        routes = db.collection('Route').where('Active','==',True).get()
        routesList = []
        for r in routes:
            rDict = r.to_dict()
            route = Route()
            route.Id = r.id
            route.Destiny = rDict["Destiny"]
            route.Origin = rDict["Origin"]
            route.Number = rDict["Number"]

            stopModel = StopModel()
            destiny = stopModel.getStopById(rDict["Destiny"])
            origin = stopModel.getStopById(rDict["Origin"])
            route.DestinyName = destiny.Name
            route.OriginName = origin.Name

            routesList.append(route)

        return routesList
    
    def getRouteById(self, id):
        route = db.collection('Route').document(id).get()
        routeDict = route.to_dict()
        return routeDict
    
    def getStopWithBiggestWaitingTimeByRouteAndDate(self, route, date):
        nextDay = date + timedelta(days=1)
        stopsByRoute = db.collection('RouteStops').where("RouteId","==",route).get()
        timesByStop = {}

        for stopRoute in stopsByRoute:
            stopRouteDict = stopRoute.to_dict()
            currentTrips = db.collection('CurrentTrip').where("StopId","==",stopRouteDict["StopId"]).where("IntendedTime",">=",date).where("IntendedTime","<",nextDay).get()

            for currentTrip in currentTrips:
                currentTripDict = currentTrip.to_dict()
                timeSpan = currentTripDict["ActualTime"] - currentTripDict["IntendedTime"] #Check if thats the right way or it even works

                stop = db.collection('Stop').document(stopRouteDict["StopId"]).get()
                stopDict = stop.to_dict()
                
                if stopDict["Name"] not in timesByStop.keys() or timesByStop[stopDict["Name"]] < timeSpan:
                    timesByStop[stopDict["Name"]] = timeSpan

        print(timesByStop)
        if (timesByStop != {}):
            return max(timesByStop, key=timesByStop.get)
        else:
            return ""
        
    #Update
    def updateRoute(self, route):
        routes = db.collection('Route')
        routes.document(route.Id).update(
            {
                'Destiny': route.Destiny,
                'Origin': route.Origin,
                'Price': route.Price
            }
        )
        
    #Delete
    def deleteRouteById(self, id):
        db.collection('Route').document(id).update({'Active': False})

        routeStopsModel = RouteStopsModel()
        routeStopsModel.deleteRouteStopsByRouteId(id)