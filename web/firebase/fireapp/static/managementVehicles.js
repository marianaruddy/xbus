function deleteVehicle(vehicleId) {  
    var a = document.getElementById('deleteLink');
    a.href = "vehicles/delete/" + vehicleId;
}