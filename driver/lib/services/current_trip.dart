import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/current_trip.dart';
import 'package:flutter/material.dart';

class CurrentTripService {
  final CollectionReference currentTripsCollection = FirebaseFirestore.instance.collection('CurrentTrip');

  Stream<List<CurrentTrip>> get currentTrips {
    return currentTripsCollection.snapshots().map(_currentTripsFromSnapshot);
  }

  CurrentTrip createCurrentTripInstance(doc) {
    DateTime? actualTime;
    DateTime intendedTime;
    int capacityInVehicle;
    int passengersQtyAfter;
    int passengersQtyBefore;
    int passengersQtyNew;
    String? stopId;
    String? tripId;

    if ((doc.data() as Map<String, dynamic>).containsKey('ActualTime')) {
      actualTime = doc['ActualTime'] != null
          ? (doc['ActualTime'] as Timestamp).toDate()
          : null;
    } else {
      actualTime = null;
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('IntendedTime')) {
      intendedTime = doc['IntendedTime'] != null
          ? (doc['IntendedTime'] as Timestamp).toDate()
          : DateTime.now();
    } else {
      intendedTime = DateTime.now();
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('CapacityInVehicle')) {
      capacityInVehicle = doc['CapacityInVehicle'];
    } else {
      capacityInVehicle = 0;
    }

    if ((doc.data() as Map<String, dynamic>)
        .containsKey('PassengersQtyAfter')) {
      passengersQtyAfter = doc['PassengersQtyAfter'];
    } else {
      passengersQtyAfter = 0;
    }

    if ((doc.data() as Map<String, dynamic>)
        .containsKey('PassengersQtyBefore')) {
      passengersQtyBefore = doc['PassengersQtyBefore'];
    } else {
      passengersQtyBefore = 0;
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('PassengersQtyNew')) {
      passengersQtyNew = doc['PassengersQtyNew'];
    } else {
      passengersQtyNew = 0;
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('StopId')) {
      stopId = doc['StopId'];
    } else {
      stopId = '';
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('TripId')) {
      tripId = doc['TripId'];
    } else {
      tripId = '';
    }

    return CurrentTrip(
      id: doc.id,
      actualTime: actualTime,
      intendedTime: intendedTime,
      capacityInVehicle: capacityInVehicle,
      passengersQtyAfter: passengersQtyAfter,
      passengersQtyBefore: passengersQtyBefore,
      passengersQtyNew: passengersQtyNew,
      stopId: stopId,
      tripId: tripId,
    );
  }

  List<CurrentTrip> _currentTripsFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs
          .map((doc) => (createCurrentTripInstance(doc)))
          .toList();
    } catch (e) {
      debugPrint('erro: $e');
      return [];
    }
  }

  Future updateCurrentTrip(docId, data) async {
    currentTripsCollection.doc(docId).update(data);
  }

  Future<List<CurrentTrip?>> getCurrTripsFromTrip(String? tripId) async {
    return currentTripsCollection.where(
      'TripId', isEqualTo: tripId
    ).get().then((snapshot) {
        return snapshot.docs.map((doc) {
          if (doc.exists) {
            return createCurrentTripInstance(doc);
          }
          else {
            return null;
          }
        }).toList();
      },
    );
  }

  Future<CurrentTrip?> getCurrTripFromTripIdAndStopId(String? tripId, String? stopId) async {
    return currentTripsCollection.where(
      'TripId', isEqualTo: tripId
    ).where(
      'StopId', isEqualTo: stopId
    ).get().then((snapshot) {
      QueryDocumentSnapshot<Object?> doc = snapshot.docs.first;
      if (doc.exists) {
        return createCurrentTripInstance(doc);
      } else {
        return null;
      }
      },
    );
  }
}
