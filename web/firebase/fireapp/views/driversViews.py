from django.shortcuts import render,redirect
from django.core import serializers
from ..models import DriverModel
from ..forms import DriverForm

#Drivers
def managementDrivers(request):
        if not request.user.is_authenticated:
            return redirect('myLogin')
        driverModel = DriverModel()
        drivers = driverModel.getAllDrivers()

        context = {
                'drivers': drivers,
        }
        return render(request, 'Management/drivers.html', context)

def managementDriversAdd(request):
    if not request.user.is_authenticated:
        return redirect('myLogin')
    if request.method == "POST":
        form = DriverForm(request.POST)
        if form.is_valid():
            driverModel = DriverModel()
            post = form.save(commit=False)
            driverModel.createDriver(post)
        return redirect('managementDrivers')
    else:
        form = DriverForm()
    return render(request, 'Management/driversAdd.html', {'form': form})

def managementDriversEdit(request, id):
    if not request.user.is_authenticated:
        return redirect('myLogin')
    if request.method == "POST":
        form = DriverForm(request.POST)
        if form.is_valid():
            driverModel = DriverModel()
            post = form.save(commit=False)
            driverModel.updateDriver(post)
        return redirect('managementDrivers')
    else:
        driverModel = DriverModel()
        driver = driverModel.getDriverById(id)
        form = DriverForm(instance=driver)
    return render(request, 'Management/driversAdd.html', {'form': form, 'id': id})

def deleteDriver(request, id):
        driverModel = DriverModel()

        driverModel.deleteDriverById(id)

        return redirect('managementDrivers')
#End Drivers