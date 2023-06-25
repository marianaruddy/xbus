function deleteRegion(regionId) {  
    var a = document.getElementById('deleteLink');
    a.href="regions/delete/" + regionId;
}