import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

cred = credentials.Certificate("C:/Users/carlo/OneDrive/Área de Trabalho/PUC/xBus/xBus/firebase/fireapp/serviceAccountKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

#Create
def createDriver(driver):
    drivers = db.collection('Driver')
    drivers.document(driver.Id).set(
      {
        'Company': driver.Company,
        'Document': driver.Document,
        'Name': driver.Name,
        'Password': driver.Password,
        'Photo': driver.Photo
      }
    )

#Read
def getAllDrivers():
    drivers = db.collection('Driver').get()
    driversList = []
    for d in drivers:
        driversList.append(d.to_dict())

    return driversList

def getQuantityOfTripsByPeriodByDriver(startDate,endDate, driverId):
    trips = db.collection('Trip').where("ActualDepartureDate",">=",startDate).where("ActualDepartureDate","<=",endDate).where("DriverRef",">=","/Driver/"+driverId).where("DriverRef","<=","/Driver/"+driverId).get()
    tripsList = []
    for t in trips:
        tripsList.append(t.to_dict())
    return len(tripsList)

#Update

#Delete
def deleteDriverById(id):
    db.collection('Driver').document(id).delete()