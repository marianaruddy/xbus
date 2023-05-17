from django import forms

from .models import RegionModel,Vehicle,Region,Driver,Stop,Trip, RouteModel

#There should be a cleaner way to tranform into tuple (id,name)
regionModel = RegionModel()
allRegionsDict = regionModel.getAllRegions()
allRegions = []
for region in allRegionsDict:
    value = region['Name']
    key = region['Id']
    myTuple = (key, value)
    allRegions.append(myTuple)

class StopForm(forms.ModelForm):
    Id = forms.CharField(widget=forms.HiddenInput(),required=False)

    class Meta:
        model = Stop
        fields = ('Address','Name', 'RegionId','Id',)
        widgets = {
            'RegionId': forms.Select(choices=allRegions),
            'Id': forms.HiddenInput(),
        }

#There should be a cleaner way to tranform into tuple (id,name)
routeModel = RouteModel()
allRoutesDict = routeModel.getAllRoutes()
allRoutes = []
for route in allRoutesDict:
    value = route.Origin + ' - ' + route.Destiny
    key = route.Id
    myTuple = (key, value)
    allRoutes.append(myTuple)

class TripForm(forms.ModelForm):
    Id = forms.CharField(widget=forms.HiddenInput(),required=False)

    class Meta:
        model = Trip
        fields = ('RouteId','IntendedDepartureTime', 'IntendedArrivalTime','CapacityInVehicle','Id',)
        widgets = {
            'RouteId': forms.Select(choices=allRoutes),
            'IntendedDepartureTime': forms.DateTimeInput(attrs={'type': 'datetime-local'}),
            'IntendedArrivalTime': forms.DateTimeInput(attrs={'type': 'datetime-local'}),
            'Id': forms.HiddenInput(attrs={'required':False}),
        }

class VehicleForm(forms.ModelForm):
    Id = forms.CharField(widget=forms.HiddenInput(),required=False)

    class Meta:
        model = Vehicle
        fields = ('Name', 'LicensePlate','Capacity','Id',)
        widgets = {
            'Id': forms.HiddenInput(),
        }

class RegionForm(forms.ModelForm):
    Id = forms.CharField(widget=forms.HiddenInput(),required=False)

    class Meta:
        model = Region
        fields = ('Name','Id',)
        widgets = {
            'Id': forms.HiddenInput(),
        }

class DriverForm(forms.ModelForm):
    Id = forms.CharField(widget=forms.HiddenInput(),required=False)

    class Meta:
        model = Driver
        fields = ('Name','Company','Document','Email','Id',)
        widgets = {
            'Id': forms.HiddenInput(),
        }