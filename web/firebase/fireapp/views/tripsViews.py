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
        form = TripForm(request.POST, allRoutes=allRoutes)
        if form.is_valid():
            tripModel = TripModel()
            post = form.save(commit=False)
            tripModel.updateTrip(post)
        return redirect('managementTrips')
    else:
        tripModel = TripModel()
        trip = tripModel.getTripById(id)

        ticketModel = Ticket()
        tickets = ticketModel.getTicketsByTripId(id)

        if trip.Status != 'Future' and len(tickets) > 0:
            trips = tripModel.getAllActiveTrips()
            context = {
                'trips': trips,
                'canBeEdited': False,
            }
            return render(request, 'Management/trips.html', context)

        allRoutes = fillAllRoutes()
        form = TripForm(instance=trip,allRoutes=allRoutes,disableRoute=True)
    return render(request, 'Management/tripsAdd.html', {'form': form, 'id': id})

def cancelTrip(request, id):
    tripModel = TripModel()

    #tripModel.cancelTrip(id)

    return redirect('managementTrips')

def deleteTrip(request, id):
        tripModel = TripModel()

        tripModel.deleteTripById(id)

        return redirect('managementTrips')

def fillAllRoutes():
    routeModel = RouteModel()
    allRoutesDict = routeModel.getAllActiveRoutes()
    allRoutes = []
    for route in allRoutesDict:
        value = route.OriginName + ' - ' + route.DestinyName
        key = route.Id
        myTuple = (key, value)
        allRoutes.append(myTuple)
    return allRoutes
#End Trips