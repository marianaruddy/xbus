import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/route.dart';
import 'package:driver/models/trip.dart';
import 'package:driver/models/vehicle.dart';

class DatabaseService {

  final CollectionReference routeCollection = FirebaseFirestore.instance.collection('Route');

  List<RouteModel> _routeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return RouteModel(
        destiny: doc['destiny'] ?? '',
        number: doc['number'] ?? '',
        origin: doc['origin'] ?? '',
      );
    }).toList();
  }
  
  Stream<List<RouteModel>> get routes {
    return routeCollection.snapshots()
      .map(_routeListFromSnapshot);
  }

  final CollectionReference vehicleCollection = FirebaseFirestore.instance.collection('Vehicle');

  List<Vehicle> _vehicleListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Vehicle(
        licensePlate: doc['LicensePlate'] ?? '',
        capacity: doc['Capacity'] ?? 0,
      );
    }).toList();
  }
  
  Stream<List<Vehicle>> get vehicles {
    return vehicleCollection.snapshots()
      .map(_vehicleListFromSnapshot);
  }

  final CollectionReference tripCollection = FirebaseFirestore.instance.collection('Trip');

  List<Trip> _tripsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Trip(
        intendedDepartureTime: doc['IntendedDepartureTime'].toDate(),
      );
    }).toList();
  }

  Stream<List<Trip>> get trips {
    return tripCollection.snapshots()
      .map(_tripsListFromSnapshot);
  }

}