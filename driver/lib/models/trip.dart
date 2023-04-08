class Trip {
  final DateTime actualArrivalTime;
  final DateTime actualDepartureTime;
  final String driverId;
  // final DateTime driverRef;
  final DateTime intendedArrivalTime;
  final DateTime intendedDepartureTime;
  final String routeId;
  // final DateTime routeRef;
  final String vehicleId;
  // final DateTime vehicleRef;

  Trip ({
    required this.actualArrivalTime,
    required this.actualDepartureTime,
    required this.driverId,
    // required this.driverRef,
    required this.intendedArrivalTime,
    required this.intendedDepartureTime,
    required this.routeId,
    // required this.routeRef,
    required this.vehicleId,
    // required this.vehicleRef,
  });

}