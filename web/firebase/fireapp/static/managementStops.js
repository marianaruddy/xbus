function deleteStop(stopId) {  
    var a = document.getElementById('deleteLink');
    a.href = '{% url "deleteStop" id=stopId %}';
}