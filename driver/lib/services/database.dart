import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/route.dart';
import 'package:driver/models/trip.dart';
import 'package:driver/models/vehicle.dart';
import 'package:flutter/material.dart';

class DatabaseService {

  final CollectionReference routeCollection = FirebaseFirestore.instance.collection('Route');

  List<RouteModel> _routeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      String destiny;
      int number;
      String origin;
      
      if ((doc.data() as Map<String,dynamic>).containsKey('Destiny')) {
        destiny = doc['Destiny'];
      }
      else {
        destiny = '';
      }
      
      if ((doc.data() as Map<String,dynamic>).containsKey('Number')) {
        number = doc['Number'];
      }
      else {
        number = 0;
      }
      
      if ((doc.data() as Map<String,dynamic>).containsKey('Origin')) {
        origin = doc['Origin'];
      }
      else {
        origin = '';
      }

      return RouteModel(
        id: doc.id,
        destiny: destiny,
        number: number,
        origin: origin,
      );
    }).toList();
  }
  
  Stream<List<RouteModel>> get routes {
    return routeCollection.snapshots()
      .map(_routeListFromSnapshot);
  }

  DocumentReference? getRouteRefById(String? id) {
    if (id != null) {
      return routeCollection.doc(id);
    }
    return null;
  }

  Future<RouteModel?>? getRouteInstanceById(String? id) {
    try {
      if (id != null) {
        return getRouteRefById(id)?.get().then((doc) {
          if (doc.exists) {
            return RouteModel(
                id: doc.id,
                destiny: doc['Destiny'],
                number: doc['Number'],
                origin: doc['Origin']);
          } else {
            throw Exception('No such document');
          }
        });
      }
    } catch (e) {
      debugPrint('erro: $e');
    }
    return null;
  }

  final CollectionReference vehicleCollection = FirebaseFirestore.instance.collection('Vehicle');

  List<Vehicle> _vehicleListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      String licensePlate;
      int capacity;
      if ((doc.data() as Map<String,dynamic>).containsKey('LicensePlate')) {
        licensePlate = doc['LicensePlate'];
      }
      else {
        licensePlate = '';
      }
      if ((doc.data() as Map<String,dynamic>).containsKey('Capacity')) {
        capacity = doc['Capacity'];
      }
      else {
        capacity = 0;
      }
      return Vehicle(
        id: doc.id,
        licensePlate: licensePlate,
        capacity: capacity,
      );
    }).toList();
  }
  
  Stream<List<Vehicle>> get vehicles {
    return vehicleCollection.snapshots()
      .map(_vehicleListFromSnapshot);
  }

  DocumentReference? getVehicleRefById(String? id) {
    if (id != null) {
      return vehicleCollection.doc(id);
    }
    return null;
  }

  final CollectionReference tripCollection = FirebaseFirestore.instance.collection('Trip');

  Future createTrip({
    DateTime? actualArrivalTime,
    DateTime? actualDepartureTime,
    required String driverId,
    DocumentReference? driverRef,
    required DateTime intendedArrivalTime,
    required DateTime intendedDepartureTime,
    DocumentReference? routeRef,
    required String routeId,
    required String vehicleId,
    DocumentReference? vehicleRef,
  }) async {
    await tripCollection.doc().set({
      'ActualArrivalTime': actualArrivalTime,
      'ActualDepartureTime': actualDepartureTime,
      'DriverId': driverId,
      'DriverRef': driverRef,
      'IntendedArrivalTime': intendedArrivalTime,
      'IntendedDepartureTime': intendedDepartureTime,
      'RouteId': routeId,
      'RouteRef': routeRef,
      'VehicleId': vehicleId,
      'VehicleRef': vehicleRef,
    });
  }
  Future updateTrip(docId, data) async {
    tripCollection.doc(docId).update(data);
  }

  List<Trip> _tripsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      DateTime? actualArrivalTime;
      DateTime? actualDepartureTime;
      String? driverId;
      DocumentReference? driverRef;
      DateTime intendedArrivalTime;
      DateTime intendedDepartureTime;
      String routeId;
      DocumentReference? routeRef;
      String vehicleId;
      DocumentReference? vehicleRef;

      
      if ((doc.data() as Map<String,dynamic>).containsKey('ActualArrivalTime')) {
        actualArrivalTime = doc['ActualArrivalTime'] != null ? (doc['ActualArrivalTime'] as Timestamp).toDate() : null;
      }
      else {
        actualArrivalTime = null;
      }

      if ((doc.data() as Map<String,dynamic>).containsKey('ActualDepartureTime')) {
        actualDepartureTime = doc['ActualDepartureTime'] != null ? (doc['ActualDepartureTime'] as Timestamp).toDate() : null;
      }
      else {
        actualDepartureTime = null;
      }

      if ((doc.data() as Map<String,dynamic>).containsKey('DriverId')) {
        driverId = doc['DriverId'];
      }
      else {
        driverId = '';
      }

      if ((doc.data() as Map<String,dynamic>).containsKey('DriverRef')) {
        driverRef = doc['DriverRef'];
      }

      if ((doc.data() as Map<String,dynamic>).containsKey('IntendedArrivalTime')) {
        intendedArrivalTime = (doc['IntendedArrivalTime'] as Timestamp).toDate();
      }
      else {
        intendedArrivalTime = DateTime.now();
      }

      if ((doc.data() as Map<String,dynamic>).containsKey('IntendedDepartureTime')) {
        intendedDepartureTime = (doc['IntendedDepartureTime'] as Timestamp).toDate();
      }
      else {
        intendedDepartureTime = DateTime.now();
      }

      if ((doc.data() as Map<String,dynamic>).containsKey('RouteId')) {
        routeId = doc['RouteId'];
      }
      else {
        routeId = '';
      }

      if ((doc.data() as Map<String,dynamic>).containsKey('RouteRef')) {
        routeRef = doc['RouteRef'];
      }

      if ((doc.data() as Map<String,dynamic>).containsKey('VehicleId')) {
        vehicleId = doc['VehicleId'];
      }
      else {
        vehicleId = '';
      }

      if ((doc.data() as Map<String,dynamic>).containsKey('VehicleRef')) {
        vehicleRef = doc['VehicleRef'];
      }

      return Trip(
        id: doc.id,
        actualArrivalTime: actualArrivalTime,
        actualDepartureTime: actualDepartureTime,
        driverId: driverId,
        driverRef: driverRef,
        intendedArrivalTime: intendedArrivalTime,
        intendedDepartureTime: intendedDepartureTime,
        routeId: routeId,
        routeRef: routeRef,
        vehicleId: vehicleId,
        vehicleRef: vehicleRef,
      );
    }).toList();
  }

  Stream<List<Trip>> get trips {
    return tripCollection.snapshots()
      .map(_tripsListFromSnapshot);
  }
}
