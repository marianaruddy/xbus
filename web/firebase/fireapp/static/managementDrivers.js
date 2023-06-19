function deleteDriver(driverId) {  
    var a = document.getElementById('deleteLink');
    a.href = '{% url "deleteDriver" id=driverId %}';
}