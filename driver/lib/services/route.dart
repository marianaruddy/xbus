import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/route.dart';
import 'package:flutter/material.dart';

class RouteService {
  final CollectionReference routeCollection = FirebaseFirestore.instance.collection('Route');

  RouteModel createRouteInstance(doc) {
    String destiny;
    int number;
    String origin;

    if ((doc.data() as Map<String, dynamic>).containsKey('Destiny')) {
      destiny = doc['Destiny'];
    } else {
      destiny = '';
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('Number')) {
      number = doc['Number'];
    } else {
      number = 0;
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('Origin')) {
      origin = doc['Origin'];
    } else {
      origin = '';
    }

    return RouteModel(
      id: doc.id,
      destiny: destiny,
      number: number,
      origin: origin,
    );
  }

  List<RouteModel> _routeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => (createRouteInstance(doc))).toList();
  }

  Stream<List<RouteModel>> get routes {
    return routeCollection.snapshots().map(_routeListFromSnapshot);
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
}
