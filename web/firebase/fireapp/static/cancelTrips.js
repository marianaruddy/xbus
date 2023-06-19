function cancelTrip(id) {
    var a = document.getElementById('cancelLink');
    console.log(id);
    a.href = '{% url "cancelTrip" id=id %}';
}