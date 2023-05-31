from django.db import models

from .driver import *

from firebase_admin import firestore

db = firestore.client()

class RegionModel(models.Model):

    #Create
    def createRegion(self, region):
        regionDict = {
                'Name': region.Name
            }
        db.collection('Region').add(regionDict)

    #Read
    def getAllRegions(self):
        regions = db.collection('Region').get()
        regionsList = []
        for r in regions:
            rDict = r.to_dict()
            rDict["Id"] = r.id
            regionsList.append(rDict)

        return regionsList
    
    def getRegionById(self, id):
        region = db.collection('Region').document(id).get()
        regionDict = region.to_dict()
        regionModel = Driver()
        regionModel.Id = id
        regionModel.Name = regionDict["Name"]
        return regionModel

    #Update
    def updateRegion(self, region):
        regions = db.collection('Region')
        regions.document(region.Id).set(
            {
                'Name': region.Name,
            }
        )

    #Delete
    def deleteRegionById(self, id):
        db.collection('Region').document(id).delete()