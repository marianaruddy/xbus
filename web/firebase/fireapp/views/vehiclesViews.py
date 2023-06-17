from django.shortcuts import render,redirect
from ..models import VehicleModel
from ..forms import VehicleForm

#Vehicles
def managementVehicles(request):
        if not request.user.is_authenticated:
            return redirect('myLogin')
        vehicleModel = VehicleModel()
        vehicles = vehicleModel.getAllVehicles()

        context = {
                'vehicles': vehicles,
        }
        return render(request, 'Management/vehicles.html', context)

def managementVehiclesAdd(request):
    if not request.user.is_authenticated:
        return redirect('myLogin')
    if request.method == "POST":
        form = VehicleForm(request.POST)
        if form.is_valid():
            vehicleModel = VehicleModel()
            post = form.save(commit=False)
            vehicleModel.createVehicle(post)
        return redirect('managementVehicles')
    else:
        form = VehicleForm()
    return render(request, 'Management/vehiclesAdd.html', {'form': form})

def managementVehiclesEdit(request, id):
    if not request.user.is_authenticated:
        return redirect('myLogin')
    if request.method == "POST":
        form = VehicleForm(request.POST)
        if form.is_valid():
            vehicleModel = VehicleModel()
            post = form.save(commit=False)
            vehicleModel.updateVehicle(post)
        return redirect('managementVehicles')
    else:
        vehicleModel = VehicleModel()
        vehicle = vehicleModel.getVehicleById(id)
        form = VehicleForm(instance=vehicle)
    return render(request, 'Management/vehiclesAdd.html', {'form': form, 'id': id})

def deleteVehicle(request, id):
        vehicleModel = VehicleModel()

        vehicleModel.deleteVehicleById(id)

        return redirect('managementVehicles')
#End Vehicles