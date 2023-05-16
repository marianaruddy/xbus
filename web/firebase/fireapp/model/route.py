import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from datetime import datetime, timedelta

cred = credentials.Certificate("C:/Users/carlo/OneDrive/Área de Trabalho/PUC/xBus/xBus/firebase/fireapp/serviceAccountKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

#Create
def createRoute(route):
    routes = db.collection('Route')
    routes.document(route.Id).set(
      {
        'Destiny': route.Destiny,
        'Number': route.Number,
        'Origin': route.Origin
      }
    )

#Read
def getAllRoutes():
    routes = db.collection('Route').get()
    routesList = []
    for r in routes:
        routesList.append(r.to_dict())

    return routesList

def getNumberOfPassengersByRouteAndDate(route, date):
    nextDay = date + timedelta(days=1)
    trips = db.collection('Trip').where("RouteId","==",route).where("ActualDepartureTime",">=",date).where("ActualDepartureTime","<",nextDay).get()
    numberOfPassengers = 0
    for t in trips:
        trip = t.to_dict()
        numberOfPassengers = numberOfPassengers + trip["PassengersQty"]
        
    return numberOfPassengers


def getStopWithMostPassengersByRouteAndDate(route,date):
    nextDay = date + timedelta(days=1)
    stopsByRoute = db.collection('RouteStops').where("RouteId","==",route).get()
    numberOfPassengersByStop = {}
    for stop in stopsByRoute:
        numberOfPassengers = len(db.collection('Tickets').where("StopId","==",stop.id).where("BoardingHour",">=",date).where("BoardingHour","<",nextDay).where("Checked", "==", True).get())
        stopDict = stop.to_dict()
        numberOfPassengersByStop[stopDict["Name"]] = numberOfPassengers
    
    return max(numberOfPassengersByStop.values())

def getNumberOfPassengersInStopWithMostPassengersByRouteAndDate(route, date):
    nextDay = date + timedelta(days=1)
    stopsByRoute = db.collection('RouteStops').where("RouteId","==",route).get()
    numberOfPassengersByStop = {}
    for stop in stopsByRoute:
        numberOfPassengers = len(db.collection('Tickets').where("StopId","==",stop.id).where("BoardingHour",">=",date).where("BoardingHour","<",nextDay).where("Checked", "==", True).get())
        stopDict = stop.to_dict()
        numberOfPassengersByStop[stopDict["Name"]] = numberOfPassengers
    
    return max(numberOfPassengersByStop, key=numberOfPassengersByStop.get)

def getStopWithBiggestWaitingTimeByRouteAndDate(route, date):
    nextDay = date + timedelta(days=1)
    stopsByRoute = db.collection('RouteStops').where("RouteId","==",route).get()
    timesByStop = {}
    for stop in stopsByRoute:
        currentTrips = db.collection('CurrentTrip').where("StopId","==",stop.id).where("IntendedTime",">=",date).where("IntendedTime","<",nextDay).get()
        stopDict = stop.to_dict()
        for currentTrip in currentTrips:
            currentTripDict = currentTrip.to_dict()
            timeSpan = currentTripDict["ActualTime"] - currentTripDict["IntendedTime"] #Check if thats the right way or it even works
            if stopDict["Name"] not in timesByStop.keys() or timesByStop[stopDict["Name"]] < timeSpan:
                timesByStop[stopDict["Name"]] = timeSpan

    return max(timesByStop, key=timesByStop.get)

def getBiggestWaitingTimeInAStopByRouteAndDate(route, date):
    nextDay = date + timedelta(days=1)
    stopsByRoute = db.collection('RouteStops').where("RouteId","==",route).get()
    timesByStop = {}
    for stop in stopsByRoute:
        currentTrips = db.collection('CurrentTrip').where("StopId","==",stop.id).where("IntendedTime",">=",date).where("IntendedTime","<",nextDay).get()
        stopDict = stop.to_dict()
        for currentTrip in currentTrips:
            currentTripDict = currentTrip.to_dict()
            timeSpan = currentTripDict["ActualTime"] - currentTripDict["IntendedTime"] #Check if thats the right way or it even works
            if stopDict["Name"] not in timesByStop.keys() or timesByStop[stopDict["Name"]] < timeSpan:
                timesByStop[stopDict["Name"]] = timeSpan

    return max(timesByStop.values())

def getStopWithShortestWaitingTimeByRouteAndDate(route, date):
    nextDay = date + timedelta(days=1)
    stopsByRoute = db.collection('RouteStops').where("RouteId","==",route).get()
    timesByStop = {}
    for stop in stopsByRoute:
        currentTrips = db.collection('CurrentTrip').where("StopId","==",stop.id).where("IntendedTime",">=",date).where("IntendedTime","<",nextDay).get()
        stopDict = stop.to_dict()
        for currentTrip in currentTrips:
            currentTripDict = currentTrip.to_dict()
            timeSpan = currentTripDict["ActualTime"] - currentTripDict["IntendedTime"] #Check if thats the right way or it even works
            if stopDict["Name"] not in timesByStop.keys() or timesByStop[stopDict["Name"]] > timeSpan:
                timesByStop[stopDict["Name"]] = timeSpan

    return min(timesByStop, key=timesByStop.get)

def getShortestWaitingTimeInAStopByRouteAndDate(route, date):
    nextDay = date + timedelta(days=1)
    stopsByRoute = db.collection('RouteStops').where("RouteId","==",route).get()
    timesByStop = {}
    for stop in stopsByRoute:
        currentTrips = db.collection('CurrentTrip').where("StopId","==",stop.id).where("IntendedTime",">=",date).where("IntendedTime","<",nextDay).get()
        stopDict = stop.to_dict()
        for currentTrip in currentTrips:
            currentTripDict = currentTrip.to_dict()
            timeSpan = currentTripDict["ActualTime"] - currentTripDict["IntendedTime"] #Check if thats the right way or it even works
            if stopDict["Name"] not in timesByStop.keys() or timesByStop[stopDict["Name"]] > timeSpan:
                timesByStop[stopDict["Name"]] = timeSpan

    return min(timesByStop.values())

def getAverageWaitingTimeByRouteAndDate(route, date):
    nextDay = date + timedelta(days=1)
    tripsByRoute = db.collection('Trip').where("RouteId","==",route).where("IntendedDepartureTime",">=",date).where("IntendedDepartureTime","<",nextDay).get()

    timesByTrip = 0
    countTrip = 0

    for trip in tripsByRoute:
        currentTrips = db.collection('CurrentTrip').where("TripId","==",trip.id).get()

        countTrip = countTrip + 1
        count = 0
        sumTimeSpan = 0

        for currentTrip in currentTrips:
            count = count + 1
            currentTripDict = currentTrip.to_dict()
            timeSpan = currentTripDict["ActualTime"] - currentTripDict["IntendedTime"] #Check if thats the right way or it even works
            sumTimeSpan = sumTimeSpan + timeSpan

        meanByTrip = (sumTimeSpan/count)
        timesByTrip = timesByTrip + meanByTrip
    
    return timesByTrip/countTrip



#Update

#Delete
def deleteRouteById(id):
    db.collection('Route').document(id).delete()