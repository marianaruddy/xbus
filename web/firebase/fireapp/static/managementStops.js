function deleteStop(stopId) {  
    var a = document.getElementById('deleteLink');
    a.href = "stops/delete/" + stopId;
}