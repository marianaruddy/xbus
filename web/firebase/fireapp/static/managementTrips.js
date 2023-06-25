function deleteTrip(tripId) {  
    var a = document.getElementById('deleteLink');
    a.href = "trips/delete/" + tripId;
}