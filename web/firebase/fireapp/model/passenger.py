import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

cred = credentials.Certificate("C:/Users/carlo/OneDrive/Área de Trabalho/PUC/xBus/xBus/firebase/fireapp/serviceAccountKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

#Create
def createPassenger(passenger):
    passengers = db.collection('Passenger')
    passengers.document(passenger.Id).set(
      {
        'Balance': passenger.Balance,
        'Document': passenger.Document,
        'Name': passenger.Name,
        'Password': passenger.Password,
        'Photo': passenger.Photo,
        'Type': passenger.Type
      }
    )

#Read
def getAllPassengers():
    passengers = db.collection('Passenger').get()
    passengersList = []
    for p in passengers:
        passengersList.append(p.to_dict())

    return passengersList

def getAllTicketsOfPassenger(passengerId):
    passenger = db.collection('Passenger').document(passengerId).get()
    print(f'Teste: {passenger.to_dict()}')


#Update

#Delete
def deletePassengerById(id):
    db.collection('Passenger').document(id).delete()