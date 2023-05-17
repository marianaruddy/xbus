import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

cred = credentials.Certificate("C:/Users/carlo/OneDrive/Área de Trabalho/PUC/xBus/xBus/firebase/fireapp/serviceAccountKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

#Create
def createTicket(ticket):
    tickets = db.collection('Ticket')
    tickets.document(ticket.Id).set(
      {
        'BoardingHour': ticket.BoardingHour,
        'Price': ticket.Price,
        'StopRef': ticket.StopRef
      }
    )

#Read
def getAllTickets():
    tickets = db.collection('Ticket').get()
    ticketsList = []
    for t in tickets:
        ticketsList.append(t.to_dict())

    return ticketsList

def getQuantityOfTicketsBoughtByPeriod(startDate, endDate):
    tickets = db.collection('Ticket').where("BoardingHour",">=",startDate).where("BoardingHour","<=",endDate).get()
    ticketsList = []
    for t in tickets:
        ticketsList.append(t.to_dict())

    return len(ticketsList)

#Update

#Delete
def deleteTicketById(id):
    db.collection('Ticket').document(id).delete()