from django.shortcuts import render,redirect
from django.http import HttpResponse
import json
from ..models import StopModel, Stop, RegionModel, RouteStopsModel
from ..forms import StopForm
from decimal import Decimal

#Stops
def searchStops(request):
    if request.method == 'GET':
        stopModel = StopModel()
        stops = stopModel.getAllStops()

        response_data = stops

        return HttpResponse(
            json.dumps(response_data),
            content_type="application/json"
        )

    else:
        return HttpResponse(
            json.dumps({"nothing to see": "this isn't happening"}),
            content_type="application/json"
        )

def managementStops(request):
        if not request.user.is_authenticated:
            return redirect('myLogin')
        stopModel = StopModel()
        stops = stopModel.getAllStops()

        context = {
                'stops': stops,
                'hasRouteAssociatedToStop': False,
        }
        return render(request, 'Management/stops.html', context)

def managementStopsAdd(request):
    if not request.user.is_authenticated:
        return redirect('myLogin')
    if request.method == "POST":
        allRegions = fillAllRegions()
        form = StopForm(request.POST, allRegions=allRegions)
        if form.is_valid():
            stopModel = StopModel()
            stop = Stop()
            
            stop.Address = request.POST["map"]
            stop.Name = form.cleaned_data.get('Name')
            stop.RegionId = form.cleaned_data.get('RegionId')
            stop.Latitude = Decimal(request.POST["latitude"])
            stop.Longitude = Decimal(request.POST["longitude"])

            stopModel.createStop(stop)
        return redirect('managementStops')
    else:
        allRegions = fillAllRegions()
        form = StopForm(allRegions=allRegions)
    return render(request, 'Management/stopsAdd.html', {'form': form})

def managementStopsEdit(request, id):
    if not request.user.is_authenticated:
        return redirect('myLogin')
    if request.method == "POST":
        allRegions = fillAllRegions()
        form = StopForm(request.POST, allRegions=allRegions)
        if form.is_valid():
            stopModel = StopModel()
            post = form.save(commit=False)

            stopModel.updateStop(post)
        return redirect('managementStops')
    else:
        stopModel = StopModel()
        stop = stopModel.getStopById(id)
        allRegions = fillAllRegions()
        form = StopForm(instance=stop, allRegions=allRegions)
    return render(request, 'Management/stopsAdd.html', {'form': form, 'address': stop.Address, 'latitude': stop.Latitude, 'longitude': stop.Longitude, 'id': id})

def deleteStop(request, id):
        stopModel = StopModel()

        routeStopsModel = RouteStopsModel()
        if len(routeStopsModel.getRouteStopsByStopId(id)) > 0:
                stops = stopModel.getAllStops()
                context = {
                        'stops': stops,
                        'hasRouteAssociatedToStop': True,
                }
                return render(request, 'Management/stops.html', context)

        stopModel.deleteStopById(id)

        return redirect('managementStops')

def fillAllRegions():
    regionModel = RegionModel()
    allRegionsDict = regionModel.getAllActiveRegions()
    allRegions = []
    for region in allRegionsDict:
        value = region['Name']
        key = region['Id']
        myTuple = (key, value)
        allRegions.append(myTuple)
    return allRegions
#End Stops