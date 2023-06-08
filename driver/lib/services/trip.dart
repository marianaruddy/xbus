import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/trip.dart';

class TripService {
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

  Trip createTripInstance(doc) {
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

    if ((doc.data() as Map<String, dynamic>).containsKey('ActualArrivalTime')) {
      actualArrivalTime = doc['ActualArrivalTime'] != null
        ? (doc['ActualArrivalTime'] as Timestamp).toDate()
        : null;
    } else {
      actualArrivalTime = null;
    }

    if ((doc.data() as Map<String, dynamic>)
        .containsKey('ActualDepartureTime')) {
      actualDepartureTime = doc['ActualDepartureTime'] != null
        ? (doc['ActualDepartureTime'] as Timestamp).toDate()
        : null;
    } else {
      actualDepartureTime = null;
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('DriverId')) {
      driverId = doc['DriverId'];
    } else {
      driverId = '';
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('DriverRef')) {
      driverRef = doc['DriverRef'];
    }

    if ((doc.data() as Map<String, dynamic>)
        .containsKey('IntendedArrivalTime')) {
      intendedArrivalTime = (doc['IntendedArrivalTime'] as Timestamp).toDate();
    } else {
      intendedArrivalTime = DateTime.now();
    }

    if ((doc.data() as Map<String, dynamic>)
        .containsKey('IntendedDepartureTime')) {
      intendedDepartureTime =
          (doc['IntendedDepartureTime'] as Timestamp).toDate();
    } else {
      intendedDepartureTime = DateTime.now();
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('RouteId')) {
      routeId = doc['RouteId'];
    } else {
      routeId = '';
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('RouteRef')) {
      routeRef = doc['RouteRef'];
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('VehicleId')) {
      vehicleId = doc['VehicleId'];
    } else {
      vehicleId = '';
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('VehicleRef')) {
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
  }

  List<Trip> _tripsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => (
      createTripInstance(doc)
    )).toList();
  }

  Stream<List<Trip>> get trips {
    return tripCollection.snapshots().map(_tripsListFromSnapshot);
  }
}
