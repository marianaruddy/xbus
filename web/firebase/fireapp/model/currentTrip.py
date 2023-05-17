import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

cred = credentials.Certificate("C:/Users/carlo/OneDrive/Área de Trabalho/PUC/xBus/xBus/firebase/fireapp/serviceAccountKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

#Create
def createCurrentTrip(currentTrip):
    currentTrips = db.collection('CurrentTrip')
    currentTrips.document(currentTrip.Id).set(
      {
        'ActualTime': currentTrip.ActualTime,
        'IntendedTime': currentTrip.Intendedtime,
        'PassengersQtyAfter': currentTrip.PassengersQtyAfter,
        'PassengersQtyBefore': currentTrip.PassengersQtyBefore,
        'PassengersQtyNew': currentTrip.PassengersQtyNew,
        'StopRef': currentTrip.StopRef,
        'TripRef': currentTrip.TripRef
      }
    )

#Read
def getAllCurrentTrips():
    currentTrips = db.collection('CurrentTrip').get()
    currentTripsList = []
    for c in currentTrips:
        currentTripsList.append(c.to_dict())

    return currentTripsList

#Update

#Delete
def deleteCurrentTripById(id):
    db.collection('CurrentTrip').document(id).delete()