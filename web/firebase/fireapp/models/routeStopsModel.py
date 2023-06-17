from django.db import models

from firebase_admin import firestore
from .stopModel import *

db = firestore.client()

class RouteStopsModel(models.Model):

    #Read
    def getStopsFromRouteId(self, routeId):
        routeStopsByRouteId = db.collection('RouteStops').where('RouteId','==',routeId).order_by('Order').get()
        stopsList = []
        stopModel = StopModel()
        for r in routeStopsByRouteId:
            rDict = r.to_dict()
            stop = stopModel.getStopById(rDict['StopId'])
            stopsList.append(stop)
        return stopsList
    
    def getStopsDictNoCoordsFromRouteId(self, routeId):
        routeStopsByRouteId = db.collection('RouteStops').where('RouteId','==',routeId).get()
        stopsList = []
        stopModel = StopModel()
        print(routeStopsByRouteId.sort(key=self.orderByOrder))
        for r in routeStopsByRouteId:
            rDict = r.to_dict()
            stop = stopModel.getStopDictNoCoordsById(rDict['StopId'])
            stopsList.append(stop)
        return stopsList
    
    def getRouteStopsFromRouteIdAndStopId(self, routeId, stopId):
        routeStopsByRouteIdAndStopId = db.collection('RouteStops').where('RouteId','==',routeId).where('StopId','==',stopId).get()
        routeStopsDict = {}
        if len(routeStopsByRouteIdAndStopId) > 0:
            routeStops = routeStopsByRouteIdAndStopId[0]
            routeStopsDict = routeStops.to_dict()
            routeStopsDict["Id"] = routeStops.id
            return routeStopsDict

        return routeStopsDict

    #Create
    def createRouteStops(self, routeId, stopId, order):
        routeStopsDict = {
                'RouteId': routeId,
                'StopId': stopId, 
                'Order': order
            }
        db.collection('RouteStops').add(routeStopsDict)

    #Update
    def updateRouteStops(self, routeStops):
        routesStops = db.collection('RouteStops')
        routesStops.document(routeStops["Id"]).set(
            {
                'RouteId': routeStops["RouteId"],
                'StopId': routeStops["StopId"], 
                'Order': routeStops["Order"]
            }
        )

    #Aux
    def orderByOrder(self,e):
        e = e.to_dict()
        return e['Order']