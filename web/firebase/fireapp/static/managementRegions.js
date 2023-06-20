function deleteRegion(regionId) {  
    var a = document.getElementById('deleteLink');
    a.href = '{% url "deleteRegion" id=regionId %}';
}