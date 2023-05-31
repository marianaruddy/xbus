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
    
    def getTicketsGeneratedByPeriod(self, startDate, endDate):
        tickets = db.collection('Ticket').where("BoardingHour",">=",startDate).where("BoardingHour","<=",endDate).get()
        ticketsList = []
        for t in tickets:
            ticketsList.append(t.to_dict())

        return ticketsList
    
    def getQuantityOfTicketsGeneratedByPeriod(self, startDate, endDate):
        tickets = db.collection('Ticket').where("BoardingHour",">=",startDate).where("BoardingHour","<",endDate).get()
        ticketsList = []
        for t in tickets:
            ticketsList.append(t.to_dict())

        return len(ticketsList)
    
    #Update

    #Delete
    def deleteTicketById(self, id):
        db.collection('Ticket').document(id).delete()