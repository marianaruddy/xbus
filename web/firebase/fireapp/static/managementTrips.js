function deleteTrip(tripId) {  
    var a = document.getElementById('deleteLink');
    a.href = '{% url "deleteTrip" id=tripId %}';
}

function cancelTrip(tripId) {
    console.log('OII');
}