import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/route.dart';
import 'package:driver/models/ticket.dart';
import 'package:driver/models/trip.dart';
import 'package:driver/models/vehicle.dart';

class DatabaseService {

  final CollectionReference routeCollection = FirebaseFirestore.instance.collection('Route');

  List<RouteModel> _routeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return RouteModel(
        id: doc.id,
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

  DocumentReference? getRouteRefById(String? id) {
    if (id != null) {
      return routeCollection.doc(id);
    }
    return null;
  }

  final CollectionReference vehicleCollection = FirebaseFirestore.instance.collection('Vehicle');

  List<Vehicle> _vehicleListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Vehicle(
        id: doc.id,
        licensePlate: doc['LicensePlate'] ?? '',
        capacity: doc['Capacity'] ?? 0,
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
      return Trip(
        id: doc.id,
        actualArrivalTime: doc['ActualArrivalTime'] != null ? (doc['ActualArrivalTime'] as Timestamp).toDate() : null,
        actualDepartureTime: doc['ActualDepartureTime'] != null ? (doc['ActualDepartureTime'] as Timestamp).toDate() : null,
        driverId: doc['DriverId'] ?? '',
        driverRef: doc['DriverRef'],
        intendedArrivalTime: (doc['IntendedArrivalTime'] as Timestamp).toDate(),
        intendedDepartureTime: (doc['IntendedDepartureTime'] as Timestamp).toDate(),
        routeId: doc['RouteId'] ?? '',
        routeRef: doc['RouteRef'],
        vehicleId: doc['VehicleId'] ?? '',
        vehicleRef: doc['VehicleRef'],
      );
    }).toList();
  }

  Stream<List<Trip>> get trips {
    return tripCollection.snapshots()
      .map(_tripsListFromSnapshot);
  }

  final CollectionReference driverCollection = FirebaseFirestore.instance.collection('Driver');
  
  Future updateDriver(String uid, String? email, String? company, String? document, String? name, String? photo) async {
    FirebaseFirestore.instance.collection('Driver').doc(uid).update({
      'Email': email,
      'Company': company,
      'Document': document,
      'Name': name,
      'Photo': photo,
    });
  }

  DocumentReference? getDriverRefById(String? id) {
    if (id != null) {
      return driverCollection.doc(id);
    }
    return null;
  }

  final CollectionReference ticketCollection = FirebaseFirestore.instance.collection('Ticket');

  List<Ticket> _ticketFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return Ticket(
          id: doc.id,
          boardingHour: doc['BoardingHour'] != null ? (doc['BoardingHour'] as Timestamp).toDate() : null,
          checked: doc['Checked'] ?? false,
          price: doc['Price'],
          stopId: doc['StopId'] ?? '',
          stopRef: doc['StopRef'],
        );
      }).toList();
      
    } catch (e) {
      print('erro: $e');
      return [];
    }
  }
  
  Stream<List<Ticket>> get tickets {
    return ticketCollection.snapshots()
      .map(_ticketFromSnapshot);
  }

  DocumentReference? getTicketRefById(String? id) {
    if (id != null) {
      return ticketCollection.doc(id);
    }
    return null;
  }

  
  Future updateTicket(docId, data) async {
    ticketCollection.doc(docId).update(data);
  }

}