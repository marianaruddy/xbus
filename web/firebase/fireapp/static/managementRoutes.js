function deleteRoute(routeId) {  
    var a = document.getElementById('deleteLink');
    a.href = '{% url "deleteRoute" id=routeId %}';
}

function searchStops() {
    console.log("oi");
    
}