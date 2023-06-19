function deleteVehicle(vehicleId) {  
    var a = document.getElementById('deleteLink');
    a.href = '{% url "deleteVehicle" id=vehicleId %}';
}