from django.shortcuts import render,redirect
from ..models import TripModel,RouteModel
from ..forms import TripForm

#Trips
def managementTrips(request):
        tripModel = TripModel()
        trips = tripModel.getAllTrips()

        context = {
                'trips': trips,
        }
        return render(request, 'Management/trips.html', context)

def managementTripsAdd(request):
    if request.method == "POST":
        allRoutes = fillAllRoutes()
        form = TripForm(request.POST, allRoutes=allRoutes)
        if form.is_valid():
            tripModel = TripModel()
            post = form.save(commit=False)
            tripModel.createTrip(post)
            return redirect('managementTrips')
        
    else:
        allRoutes = fillAllRoutes()
        form = TripForm(allRoutes=allRoutes)
    return render(request, 'Management/tripsAdd.html', {'form': form})

def managementTripsEdit(request, id):
    if request.method == "POST":
        allRoutes = fillAllRoutes()
        form = TripForm(request.POST, allRoutes=allRoutes)
        if form.is_valid():
            tripModel = TripModel()
            post = form.save(commit=False)
            tripModel.updateTrip(post)
        return redirect('managementTrips')
    else:
        tripModel = TripModel()
        trip = tripModel.getTripById(id)
        allRoutes = fillAllRoutes()
        form = TripForm(instance=trip,allRoutes=allRoutes)
    return render(request, 'Management/tripsAdd.html', {'form': form})

def deleteTrip(request, id):
        tripModel = TripModel()

        tripModel.deleteTripById(id)

        return redirect('managementTrips')

def fillAllRoutes():
    routeModel = RouteModel()
    allRoutesDict = routeModel.getAllRoutes()
    allRoutes = []
    for route in allRoutesDict:
        value = route.OriginName + ' - ' + route.DestinyName
        key = route.Id
        myTuple = (key, value)
        allRoutes.append(myTuple)
    return allRoutes
#End Trips