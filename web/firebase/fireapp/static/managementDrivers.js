function deleteDriver(driverId) {  
    var a = document.getElementById('deleteLink');
    a.href = "drivers/delete/" + driverId;
}