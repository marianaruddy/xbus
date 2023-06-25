from django.db import models

from firebase_admin import firestore

db = firestore.client()

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
    
    def getPassengerByPassengerId(self, passengerId):
        passenger = db.collection('Passenger').document(passengerId)

        return passenger
    
    def getTicketsByTripId(self, tripId):
        currentTripsByTripId = db.collection('CurrentTrip').where('TripId','==',tripId).get()

        currentTripIds = []
        for currentTrip in currentTripsByTripId:
            currentTripIds.append(currentTrip.id)

        tickets = []
        if len(currentTripIds) > 0:
            tickets = db.collection('Ticket').where('CurrentTripId','in',currentTripIds).get()

        return tickets

    def getNotUsedTicketsByTripId(self, tripId):
        currentTripsByTripId = db.collection('CurrentTrip').where('TripId','==',tripId).get()

        currentTripIds = []
        for currentTrip in currentTripsByTripId:
            currentTripIds.append(currentTrip.id)

        tickets = []
        if len(currentTripIds) > 0:
            tickets = db.collection('Ticket').where('CurrentTripId','in',currentTripIds).where('Active','==',True).where('Used','==',False).get()

        return tickets
    
    def getTicketsGeneratedByPeriod(self, startDate, endDate):
        tickets = db.collection('Ticket').where("BoardingHour",">=",startDate).where("BoardingHour","<=",endDate).get()
        ticketsList = []
        for t in tickets:
            ticketsList.append(t.to_dict())

        return ticketsList
    
    def getQuantityOfTicketsGeneratedByPeriod(self, startDate, endDate):
        currentTrips = db.collection('CurrentTrip').where("ActualTime",">=",startDate).where("ActualTime","<",endDate).get()
        if not currentTrips:
            return 0
        
        currentTripIds = []
        for currentTrip in currentTrips:
            currentTripIds.append(currentTrip.id)
            
        tickets = db.collection('Ticket').where("CurrentTripId","in",currentTripIds).get()
        ticketsList = []
        for t in tickets:
            ticketsList.append(t.to_dict())

        return len(ticketsList)
    
    #Update

    #Delete
    def deleteTicketById(self, id):
        db.collection('Ticket').document(id).delete()

    def deactivateTicket(self, id):
        db.collection('Ticket').document(id).update({'Active': False})