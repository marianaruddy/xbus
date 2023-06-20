import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  final String id;
  final bool active;
  final DateTime? actualArrivalTime;
  final DateTime? actualDepartureTime;
  final GeoPoint? currentLocation;
  final int capacityInVehicle;
  final int? passengersQty;
  final String? driverId;
  final DateTime intendedArrivalTime;
  final DateTime intendedDepartureTime;
  final String routeId;
  final String? vehicleId;

  Trip ({
    required this.id,
    required this.active,
    this.actualArrivalTime,
    this.actualDepartureTime,
    this.currentLocation,
    required this.capacityInVehicle,
    this.passengersQty,
    this.driverId,
    required this.intendedArrivalTime,
    required this.intendedDepartureTime,
    required this.routeId,
    this.vehicleId,
  });

}