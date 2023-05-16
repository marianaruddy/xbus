from django.shortcuts import render,redirect
from ..models import TripModel
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
        form = TripForm(request.POST)
        print("oi")
        if form.is_valid():
            print("ola")
            tripModel = TripModel()
            post = form.save(commit=False)
            tripModel.createTrip(post)
            return redirect('managementTrips')
        
    else:
        form = TripForm()
    return render(request, 'Management/tripsAdd.html', {'form': form})

def managementTripsEdit(request, id):
    if request.method == "POST":
        form = TripForm(request.POST)
        if form.is_valid():
            tripModel = TripModel()
            post = form.save(commit=False)
            tripModel.updateTrip(post)
        return redirect('managementTrips')
    else:
        tripModel = TripModel()
        trip = tripModel.getTripById(id)
        form = TripForm(instance=trip)
    return render(request, 'Management/tripsAdd.html', {'form': form})

def deleteTrip(request, id):
        tripModel = TripModel()

        tripModel.deleteTripById(id)

        return redirect('managementTrips')
#End Trips