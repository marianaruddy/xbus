import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

cred = credentials.Certificate("C:/Users/carlo/OneDrive/Área de Trabalho/PUC/xBus/xBus/firebase/fireapp/serviceAccountKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

#Create
def createVehicle(vehicle):
    vehicles = db.collection('Vehicle')
    vehicles.document(vehicle.Id).set(
      {
        'Capacity': vehicle.Capacity,
        'LicensePlate': vehicle.LicensePlate
      }
    )

#Read
def getAllVehicles():
    vehicles = db.collection('Vehicle').get()
    vehiclesList = []
    for v in vehicles:
        vehiclesList.append(v.to_dict())

    return vehiclesList

#Update

#Delete
def deleteVehicleById(id):
    db.collection('Vehicle').document(id).delete()