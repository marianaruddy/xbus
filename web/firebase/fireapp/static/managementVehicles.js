function deleteVehicle(id) {  
    var a = document.getElementById('deleteLink');
    a.href = "vehicles/delete/" + id;
}