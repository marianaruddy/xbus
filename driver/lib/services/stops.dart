import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/stop.dart';
import 'package:flutter/material.dart';

class StopService {
  final CollectionReference stopCollection =
      FirebaseFirestore.instance.collection('Stop');

  Stream<List<Stop>> get stops {
    return stopCollection.snapshots().map(_stopsFromSnapshot);
  }

  Stop createStopInstance(doc) {
    String address;
    String name;
    String regionId;
    GeoPoint coords;

    if ((doc.data() as Map<String, dynamic>).containsKey('Address')) {
      address = doc['Address'];
    } else {
      address = '';
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('Name')) {
      name = doc['Name'];
    } else {
      name = '';
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('RegionId')) {
      regionId = doc['RegionId'];
    } else {
      regionId = '';
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('Coords')) {
      coords = doc['Coords'];
    } else {
      coords = const GeoPoint(-22.979242, -43.231765);
    }

    return Stop(
      id: doc.id,
      address: address,
      name: name,
      regionId: regionId,
      coords: coords,
    );
  }

  List<Stop> _stopsFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) => (
        createStopInstance(doc)
      )).toList();
    } catch (e) {
      debugPrint('erro: $e');
      return [];
    }
  }

  Future<Stop?>? getStopInstanceById(String? id) {
    try {
      if (id != null) {
        return stopCollection.doc(id).get().then((doc) {
          if (doc.exists) {
            return createStopInstance(doc);
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
}
