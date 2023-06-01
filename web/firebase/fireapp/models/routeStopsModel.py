from django.db import models
from .stopModel import *
from firebase_admin import firestore

db = firestore.client()

class RouteStopsModel(models.Model):

    #Read
    def getStopsFromRouteId(self, routeId):
        routeStopsByRouteId = db.collection('RouteStops').where('RouteId','==',routeId).get()
        stopsList = []
        stopModel = StopModel()
        for r in routeStopsByRouteId:
            rDict = r.to_dict()
            stop = stopModel.getStopById(rDict['StopId'])
            stopsList.append(stop)
        return stopsList

    #Create
    def createRouteStops(self, routeId, stopId):
        routeStopsDict = {
                'RouteId': routeId,
                'StopId': stopId
            }
        db.collection('RouteStops').add(routeStopsDict)