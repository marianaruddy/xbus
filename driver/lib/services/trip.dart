import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/trip.dart';

class TripService {
  final CollectionReference tripCollection = FirebaseFirestore.instance.collection('Trip');

  Future createTrip({
    DateTime? actualArrivalTime,
    DateTime? actualDepartureTime,
    required String driverId,
    required DateTime intendedArrivalTime,
    required DateTime intendedDepartureTime,
    required String routeId,
    required String vehicleId,
  }) async {
    await tripCollection.doc().set({
      'ActualArrivalTime': actualArrivalTime,
      'ActualDepartureTime': actualDepartureTime,
      'DriverId': driverId,
      'IntendedArrivalTime': intendedArrivalTime,
      'IntendedDepartureTime': intendedDepartureTime,
      'RouteId': routeId,
      'VehicleId': vehicleId,
    });
  }

  Future updateTrip(docId, data) async {
    tripCollection.doc(docId).update(data);
  }

  Trip createTripInstance(doc) {
    DateTime? actualArrivalTime;
    DateTime? actualDepartureTime;
    GeoPoint? currentLocation;
    int capacityInVehicle;
    int? passengersQty;
    String? driverId;
    DateTime intendedArrivalTime;
    DateTime intendedDepartureTime;
    String routeId;
    String vehicleId;

    if ((doc.data() as Map<String, dynamic>).containsKey('ActualArrivalTime')) {
      actualArrivalTime = doc['ActualArrivalTime'] != null
        ? (doc['ActualArrivalTime'] as Timestamp).toDate()
        : null;
    } else {
      actualArrivalTime = null;
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('ActualDepartureTime')) {
      actualDepartureTime = doc['ActualDepartureTime'] != null
        ? (doc['ActualDepartureTime'] as Timestamp).toDate()
        : null;
    } else {
      actualDepartureTime = null;
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('CurrentLocation')) {
      currentLocation = doc['CurrentLocation'];
    } else {
      currentLocation = null;
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('CapacityInVehicle')) {
      capacityInVehicle = doc['CapacityInVehicle'];
    } else {
      capacityInVehicle = -1; //TODO: ver oq fazer aqui (throw error?)
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('PassengersQty')) {
      passengersQty = doc['PassengersQty'];
    } else {
      passengersQty = null;
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('DriverId')) {
      driverId = doc['DriverId'];
    } else {
      driverId = '';
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('IntendedArrivalTime')) {
      intendedArrivalTime = (doc['IntendedArrivalTime'] as Timestamp).toDate();
    } else {
      intendedArrivalTime = DateTime.now();
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('IntendedDepartureTime')) {
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

    if ((doc.data() as Map<String, dynamic>).containsKey('VehicleId')) {
      vehicleId = doc['VehicleId'];
    } else {
      vehicleId = '';
    }

    return Trip(
      id: doc.id,
      actualArrivalTime: actualArrivalTime,
      actualDepartureTime: actualDepartureTime,
      currentLocation: currentLocation,
      capacityInVehicle: capacityInVehicle,
      passengersQty: passengersQty,
      driverId: driverId,
      intendedArrivalTime: intendedArrivalTime,
      intendedDepartureTime: intendedDepartureTime,
      routeId: routeId,
      vehicleId: vehicleId,
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
