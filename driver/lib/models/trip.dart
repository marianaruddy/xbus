import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  final String id;
  final DateTime? actualArrivalTime;
  final DateTime? actualDepartureTime;
  final String driverId;
  final DocumentReference? driverRef;
  final DateTime intendedArrivalTime;
  final DateTime intendedDepartureTime;
  final String routeId;
  final DocumentReference? routeRef;
  final String vehicleId;
  final DocumentReference? vehicleRef;

  Trip ({
    required this.id,
    this.actualArrivalTime,
    this.actualDepartureTime,
    required this.driverId,
    this.driverRef,
    required this.intendedArrivalTime,
    required this.intendedDepartureTime,
    required this.routeId,
    this.routeRef,
    required this.vehicleId,
    this.vehicleRef,
  });

}