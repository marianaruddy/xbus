import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

cred = credentials.Certificate("C:/Users/carlo/OneDrive/Área de Trabalho/PUC/xBus/xBus/firebase/fireapp/serviceAccountKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

#Create
def createStop(stop):
    stops = db.collection('Stop')
    stops.document(stop.Id).set(
      {
        'Address': stop.Address,
        'Name': stop.Name
      }
    )

#Read
def getAllStops():
    stops = db.collection('Stop').get()
    stopsList = []
    for s in stops:
        stopsList.append(s.to_dict())

    return stopsList

def getStopById(id):
    stopRef = db.collection('Stop').document(id)
    stop = stopRef.get()
    return stop.to_dict()

#Update

#Delete
def deleteStopById(id):
    db.collection('Stop').document(id).delete()
