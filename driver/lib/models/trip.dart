class Trip {
  final String id;
  final DateTime? actualArrivalTime;
  final DateTime? actualDepartureTime;
  final String? driverId;
  final DateTime intendedArrivalTime;
  final DateTime intendedDepartureTime;
  final String routeId;
  final String vehicleId;

  Trip ({
    required this.id,
    this.actualArrivalTime,
    this.actualDepartureTime,
     this.driverId,
    required this.intendedArrivalTime,
    required this.intendedDepartureTime,
    required this.routeId,
    required this.vehicleId,
  });

}