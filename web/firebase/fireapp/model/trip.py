import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

cred = credentials.Certificate("C:/Users/carlo/OneDrive/Área de Trabalho/PUC/xBus/xBus/firebase/fireapp/serviceAccountKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

#Create
def createTrip(trip):
    trips = db.collection('Trip')
    trips.document(trip.Id).set(
      {
        'ActualArrivalTime': trip.ActualArrivalTime,
        'ActualDepartureTime': trip.ActualDepartureTime,
        'DriverRef': trip.DriverRef,
        'IntendedArrivalTime': trip.IntendedArrivalTime,
        'IntendedDepartureTime': trip.IntendedDepartureTime,
        'RouteRef': trip.RouteRef,
        'VehicleRef': trip.VehicleRef
      }
    )

#Read
def getAllTrips():
    trips = db.collection('Trip').get()
    tripsList = []
    for t in trips:
        tripsList.append(t.to_dict())

    return tripsList

#Update

#Delete
def deleteTripById(id):
    db.collection('Trip').document(id).delete()