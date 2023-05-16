import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

cred = credentials.Certificate("C:/Users/carlo/OneDrive/Área de Trabalho/PUC/xBus/xBus/firebase/fireapp/serviceAccountKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

#Create
def createRegion(region):
    regions = db.collection('Region')
    regions.document(region.Id).set(
      {
        'Name': region.Name
      }
    )

#Read
def getAllRegions():
    regions = db.collection('Region').get()
    regionsList = []
    for r in regions:
        regionsList.append(r.to_dict())

    return regionsList

def getQuantityOfPassengerByRegionAndDate(regionId, date):
    pass

#Update

#Delete
def deleteRegionById(id):
    db.collection('Region').document(id).delete()