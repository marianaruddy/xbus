from django.db import models
from datetime import datetime, timedelta

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

cred = credentials.Certificate("C:/Users/carlo/OneDrive/Área de Trabalho/PUC/xBus/xBus/firebase/fireapp/serviceAccountKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

class Stop(models.Model):
    Id = models.CharField(max_length=200)
    Address = models.CharField(max_length=200)
    Name = models.CharField(max_length=100)
    RegionId = models.CharField(max_length=100)

    def info(self):
        return f"Stop Id: {self.Id}, Name: {self.Name}, Address: {self.Address}, RegionId: {self.RegionId}"
        
class StopModel(models.Model):

    def __init__(self):
        return
    
    #Create
    def createStop(self, stop):
        stopDict = {
                'Address': stop.Address,
                'Name': stop.Name,
                'RegionId': stop.RegionId
            }
        db.collection('Stop').add(stopDict)
    
    #Read
    def getAllStops(self):
        stops = db.collection('Stop').get()
        stopsList = []
        for s in stops:
            sDict = s.to_dict()
            sDict["Id"] = s.id
            stopsList.append(sDict)

        return stopsList
    
    def getStopById(self, id):
        stop = db.collection('Stop').document(id).get()
        stopDict = stop.to_dict()
        stopModel = Stop()
        stopModel.Id = id
        stopModel.Address = stopDict["Address"]
        stopModel.Name = stopDict["Name"]
        stopModel.RegionId = stopDict["RegionId"]
        return stopModel
    
    #Update
    def updateStop(self, stop):
        print(stop.info())
        stops = db.collection('Stop')
        stops.document(stop.Id).set(
            {
                'Name': stop.Name,
                'Address': stop.Address,
                'RegionId': stop.RegionId,
            }
        )
    
    #Delete
    def deleteStopById(self, id):
        db.collection('Stop').document(id).delete()

class Region(models.Model):
    Id = models.CharField(max_length=200)
    Name = models.CharField(max_length=100)


class Route(models.Model):
    Id = models.CharField(max_length=200)
    Destiny = models.CharField(max_length=100)
    Origin = models.CharField(max_length=100)

class RouteModel(models.Model):

    def __init__(self):
        return
    
    #Create
    def createRoute(self, route):
        routeDict = {
                'Destiny': route.Destiny,
                'Origin': route.Origin
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
        
    #Delete
    def deleteRouteById(self, id):
        db.collection('Route').document(id).delete()

class RouteStops(models.Model):
    Id = models.CharField(max_length=200)

class RouteStopsModel(models.Model):

    #Read
    def getStopsFromRouteId(self, routeId):
        routeStopsByRouteId = db.collection('RouteStops').where('RouteId','==',routeId).get()
        stopsList = []
        for r in routeStopsByRouteId:
            rDict = r.to_dict()
            stopsList.append(rDict['StopId'])
        return stopsList

    #Create
    def createRouteStops(self, routeId, stopId):
        routeStopsDict = {
                'RouteId': routeId,
                'StopId': stopId
            }
        db.collection('RouteStops').add(routeStopsDict)

class Ticket(models.Model):
    Id = models.CharField(max_length=200)
    BoardingHour = models.DateTimeField()
    Checked = models.BooleanField()
    PassengerId = models.CharField(max_length=200)
    Price = models.DecimalField(max_digits=4, decimal_places=2)
    StopId = models.CharField(max_length=200)

    def __init__(self):
        return

    #Create
    def createTicket(self, ticket):
        tickets = db.collection('Ticket')
        tickets.document(ticket.Id).set(
            {
                'BoardingHour': ticket.BoardingHour,
                'Price': ticket.Price,
                'StopRef': ticket.StopRef
            }
        )

    #Read
    def getAllTickets(self):
        tickets = db.collection('Ticket').get()
        ticketsList = []
        for t in tickets:
            ticketsList.append(t.to_dict())

        return ticketsList
    
    def getQuantityOfTicketsBoughtByPeriod(self, startDate, endDate):
        tickets = db.collection('Ticket').where("BoardingHour",">=",startDate).where("BoardingHour","<=",endDate).get()
        ticketsList = []
        for t in tickets:
            ticketsList.append(t.to_dict())

        return len(ticketsList)
    
    #Update

    #Delete
    def deleteTicketById(self, id):
        db.collection('Ticket').document(id).delete()

class Vehicle(models.Model):
    Id = models.CharField(max_length=200)
    Name = models.CharField(max_length=200)
    LicensePlate = models.CharField(max_length=200)
    Capacity = models.IntegerField()

class VehicleModel(models.Model):

    #Create
    def createVehicle(self, vehicle):
        vehicleDict = {
                'Name': vehicle.Name,
                'Capacity': vehicle.Capacity,
                'LicensePlate': vehicle.LicensePlate
            }
        db.collection('Vehicle').add(vehicleDict)

    #Read
    def getAllVehicles(self):
        vehicles = db.collection('Vehicle').get()
        vehiclesList = []
        for v in vehicles:
            vDict = v.to_dict()
            vDict["Id"] = v.id
            vehiclesList.append(vDict)

        return vehiclesList
    
    def getVehicleById(self, id):
        vehicle = db.collection('Vehicle').document(id).get()
        vehicleDict = vehicle.to_dict()
        vehicleModel = Vehicle()
        vehicleModel.Id = id
        vehicleModel.Name = vehicleDict["Name"]
        vehicleModel.LicensePlate = vehicleDict["LicensePlate"]
        vehicleModel.Capacity = vehicleDict["Capacity"]
        return vehicleModel

    #Update
    def updateVehicle(self, vehicle):
        vehicles = db.collection('Vehicle')
        vehicles.document(vehicle.Id).set(
            {
                'Name': vehicle.Name,
                'LicensePlate': vehicle.LicensePlate,
                'Capacity': vehicle.Capacity,
            }
        )

    #Delete
    def deleteVehicleById(self, id):
        db.collection('Vehicle').document(id).delete()

class Region(models.Model):
    Id = models.CharField(max_length=200)
    Name = models.CharField(max_length=200)

class RegionModel(models.Model):

    #Create
    def createRegion(self, region):
        regionDict = {
                'Name': region.Name
            }
        db.collection('Region').add(regionDict)

    #Read
    def getAllRegions(self):
        regions = db.collection('Region').get()
        regionsList = []
        for r in regions:
            rDict = r.to_dict()
            rDict["Id"] = r.id
            regionsList.append(rDict)

        return regionsList
    
    def getRegionById(self, id):
        region = db.collection('Region').document(id).get()
        regionDict = region.to_dict()
        regionModel = Driver()
        regionModel.Id = id
        regionModel.Name = regionDict["Name"]
        return regionModel

    #Update
    def updateRegion(self, region):
        regions = db.collection('Region')
        regions.document(region.Id).set(
            {
                'Name': region.Name,
            }
        )

    #Delete
    def deleteRegionById(self, id):
        db.collection('Region').document(id).delete()

class Driver(models.Model):
    Id = models.CharField(max_length=200)
    Name = models.CharField(max_length=200)
    Company = models.CharField(max_length=200)
    Document = models.CharField(max_length=200)
    Email = models.EmailField()

    def info(self):
        return f"Driver Id: {self.Id}, Name: {self.Name}, Company: {self.Company}, Document: {self.Document}, Email: {self.Email}"

class DriverModel(models.Model):

    #Create
    def createDriver(self, driver):
        driverDict = {
                'Name': driver.Name,
                'Company': driver.Company,
                'Document': driver.Document,
                'Email': driver.Email
            }
        db.collection('Driver').add(driverDict)

    #Read
    def getAllDrivers(self):
        drivers = db.collection('Driver').get()
        driversList = []
        for d in drivers:
            dDict = d.to_dict()
            dDict["Id"] = d.id
            driversList.append(dDict)

        return driversList
    
    def getDriverById(self, id):
        driver = db.collection('Driver').document(id).get()
        driverDict = driver.to_dict()
        driverModel = Driver()
        driverModel.Id = id
        driverModel.Name = driverDict["Name"]
        driverModel.Company = driverDict["Company"]
        driverModel.Document = driverDict["Document"]
        driverModel.Email = driverDict["Email"]
        return driverModel

    #Update
    def updateDriver(self, driver):
        drivers = db.collection('Driver')
        drivers.document(driver.Id).set(
            {
                'Company': driver.Company,
                'Document': driver.Document,
                'Name': driver.Name,
                'Email': driver.Email,
            }
        )

    #Delete
    def deleteDriverById(self, id):
        db.collection('Driver').document(id).delete()

class CurrentTrip(models.Model):
    Id = models.CharField(max_length=200)
    ActualTime = models.DateTimeField()
    IntendedTime = models.DateTimeField()
    PassengersQtyAfter = models.IntegerField()
    PassengersQtyBefore = models.IntegerField()
    PassengersQtyNew = models.IntegerField()
    StopId = models.CharField(max_length=200)
    TripId = models.CharField(max_length=200)

class CurrentTripModel(models.Model):

    #Create
    def createCurrentTrip(self, currentTrip):
        currentTripDict = {
                'IntendedTime': currentTrip.IntendedTime,
                'StopId': currentTrip.StopId,
                'TripId': currentTrip.TripId
            }
        db.collection('CurrentTrip').add(currentTripDict)

class Trip(models.Model):
    Id = models.CharField(max_length=200)
    ActualArrivalTime = models.DateTimeField()
    ActualDepartureTime = models.DateTimeField()
    DriverId = models.CharField(max_length=200)
    IntendedArrivalTime = models.DateTimeField()
    IntendedDepartureTime = models.DateTimeField()
    PassengersQty = models.IntegerField()
    RouteId = models.CharField(max_length=200)
    VehicleId = models.CharField(max_length=200)
    CapacityInVehicle = models.IntegerField()

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

class ReportRoute(models.Model):
    NumberOfPassengers = models.IntegerField()
    StopWithMostPassengers = models.CharField(max_length=200)
    NumberOfPassengersInStopWithMostPassengers = models.IntegerField()
    StopWithBiggestWaitingTime = models.CharField(max_length=200)
    BiggestWaitingTimeInAStop = models.TimeField()
    StopWithShortestWaitingTime = models.CharField(max_length=200)
    ShortestWaitingTimeInAStop = models.TimeField()
    AverageWaitingTime = models.TimeField()
    RouteId = models.CharField(max_length=200)
    Date = models.DateField()
    
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
        date = datetime(2023,4,27)
        nextDay = date + timedelta(days=1)
        tripsThatHappened = db.collection('Trip').where("RouteId","==",route).order_by("ActualDepartureTime")
        tripsThatHappened = tripsThatHappened.where("ActualDepartureTime",">=",date).where("ActualDepartureTime","<",nextDay).get()
        numberOfPassengers = 0
        for t in tripsThatHappened:
            trip = t.to_dict()
            numberOfPassengers = numberOfPassengers + trip["PassengersQty"]
            
        return numberOfPassengers


    def getStopWithMostPassengersByRouteAndDate(self, route,date):
        nextDay = date + timedelta(days=1)
        stopsByRoute = db.collection('RouteStops').where("RouteId","==",route).get()
        numberOfPassengersByStop = {}
        for stop in stopsByRoute:
            numberOfPassengers = len(db.collection('Tickets').where("StopId","==",stop.id).where("BoardingHour",">=",date).where("BoardingHour","<",nextDay).where("Checked", "==", True).get())
            stopDict = stop.to_dict()
            numberOfPassengersByStop[stopDict["Name"]] = numberOfPassengers
        
        return max(numberOfPassengersByStop.values())

    def getNumberOfPassengersInStopWithMostPassengersByRouteAndDate(self, route, date):
        nextDay = date + timedelta(days=1)
        stopsByRoute = db.collection('RouteStops').where("RouteId","==",route).get()
        numberOfPassengersByStop = {}
        for stop in stopsByRoute:
            numberOfPassengers = len(db.collection('Tickets').where("StopId","==",stop.id).where("BoardingHour",">=",date).where("BoardingHour","<",nextDay).where("Checked", "==", True).get())
            stopDict = stop.to_dict()
            numberOfPassengersByStop[stopDict["Name"]] = numberOfPassengers
        
        return max(numberOfPassengersByStop, key=numberOfPassengersByStop.get)

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

    def getBiggestWaitingTimeInAStopByRouteAndDate(self, route, date):
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

    def getStopWithShortestWaitingTimeByRouteAndDate(self, route, date):
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

    def getShortestWaitingTimeInAStopByRouteAndDate(self, route, date):
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

    def getAverageWaitingTimeByRouteAndDate(self, route, date):
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
