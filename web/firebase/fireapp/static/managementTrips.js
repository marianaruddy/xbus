function deleteTrip(id) {  
    var a = document.getElementById('deleteLink');
    a.href = "trips/delete/" + id;
}