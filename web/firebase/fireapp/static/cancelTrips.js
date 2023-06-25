function cancelTrip(tripId) {
    var a = document.getElementById('cancelLink');
    a.href = "trips/cancel/" + tripId;
}