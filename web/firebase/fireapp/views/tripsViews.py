from django.shortcuts import render,redirect
from ..models import TripModel,RouteModel, Ticket
from ..forms import TripForm

#Trips
def managementTrips(request):
        if not request.user.is_authenticated:
            return redirect('myLogin')
        tripModel = TripModel()
        trips = tripModel.getAllActiveTrips()

        context = {
                'trips': trips,
                'canBeEdited': True,
                'canBeCancelled': True,
                'canBeDeleted': True,
        }
        return render(request, 'Management/trips.html', context)

def managementTripsAdd(request):
    if not request.user.is_authenticated:
        return redirect('myLogin')
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
    if not request.user.is_authenticated:
        return redirect('myLogin')
    if request.method == "POST":
        allRoutes = fillAllRoutes()
        form = TripForm(request.POST, allRoutes=allRoutes,disableRoute=True)
        if form.is_valid():
            tripModel = TripModel()
            post = form.save(commit=False)
            print(post.Id)
            tripModel.updateTrip(post)
        else:
            print(form.errors)
        return redirect('managementTrips')
    else:
        tripModel = TripModel()
        trip = tripModel.getTripById(id)

        ticketModel = Ticket()
        tickets = ticketModel.getTicketsByTripId(id)

        if trip.Status != 'Future' or len(tickets) > 0:
            trips = tripModel.getAllActiveTrips()
            context = {
                'trips': trips,
                'canBeEdited': False,
                'canBeCancelled': True,
                'canBeDeleted': True,
            }
            return render(request, 'Management/trips.html', context)

        allRoutes = fillAllRoutes()
        form = TripForm(instance=trip,allRoutes=allRoutes,disableRoute=True)
    return render(request, 'Management/tripsAdd.html', {'form': form, 'id': id})

def cancelTrip(request, id):
    tripModel = TripModel()
    trip = tripModel.getTripById(id)
    print(trip.Status)
    if trip.Status == 'Future' or trip.Status == 'Progress':
        tripModel.cancelTrip(id)
        return redirect('managementTrips')
    else:
        trips = tripModel.getAllActiveTrips()
        context = {
            'trips': trips,
            'canBeEdited': True,
            'canBeCancelled': False,
            'canBeDeleted': True,
        }
        return render(request, 'Management/trips.html', context)

    

def deleteTrip(request, id):
    tripModel = TripModel()
    trip = tripModel.getTripById(id)

    if trip.Status == 'Future':
        tripModel.deleteTripById(id)
        return redirect('managementTrips')
    else:
        trips = tripModel.getAllActiveTrips()
        context = {
            'trips': trips,
            'canBeEdited': True,
            'canBeCancelled': True,
            'canBeDeleted': False,
        }
        return render(request, 'Management/trips.html', context)

def fillAllRoutes():
    routeModel = RouteModel()
    allRoutesDict = routeModel.getAllActiveRoutes()
    allRoutes = []
    for route in allRoutesDict:
        value = 'Route ' + str(route.Number) + ': ' + route.OriginName + ' - ' + route.DestinyName
        key = route.Id
        myTuple = (key, value)
        allRoutes.append(myTuple)
    return allRoutes
#End Trips