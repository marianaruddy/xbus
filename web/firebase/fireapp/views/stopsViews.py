from django.shortcuts import render,redirect
from django.http import HttpResponse
import json
from ..models import StopModel, Stop
from ..forms import StopForm
from decimal import Decimal

#Stops
def searchStops(request):
    if request.method == 'GET':
        print("OI")
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
        stopModel = StopModel()
        stops = stopModel.getAllStops()

        context = {
                'stops': stops,
        }
        return render(request, 'Management/stops.html', context)

def managementStopsAdd(request):
    if request.method == "POST":
        form = StopForm(request.POST)
        if form.is_valid():
            stopModel = StopModel()
            stop = Stop()
            
            stop.Address = request.POST["addressMap"]
            stop.Name = form.cleaned_data.get('Name')
            stop.RegionId = form.cleaned_data.get('RegionId')
            stop.Latitude = Decimal(request.POST["latitude"])
            stop.Longitude = Decimal(request.POST["longitude"])

            stopModel.createStop(stop)
        return redirect('managementStops')
    else:
        form = StopForm()
    return render(request, 'Management/stopsAdd.html', {'form': form})

def managementStopsEdit(request, id):
    if request.method == "POST":
        form = StopForm(request.POST)
        if form.is_valid():
            stopModel = StopModel()
            post = form.save(commit=False)

            stopModel.updateStop(post)
        return redirect('managementStops')
    else:
        stopModel = StopModel()
        stop = stopModel.getStopById(id)
        form = StopForm(instance=stop)
    return render(request, 'Management/stopsAdd.html', {'form': form, 'address': stop.Address, 'latitude': stop.Latitude, 'longitude': stop.Longitude})

def deleteStop(request, id):
        stopModel = StopModel()

        stopModel.deleteStopById(id)

        return redirect('managementStops')
#End Stops