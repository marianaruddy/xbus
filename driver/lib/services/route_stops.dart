import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/route_stop.dart';
import 'package:flutter/material.dart';

class RouteStopsService {

  final CollectionReference routeStopCollection = FirebaseFirestore.instance.collection('RouteStops');

  RouteStop createRouteStopInstance(doc){
    String stopId;
    String routeId;
    int order;
        
    if ((doc.data() as Map<String,dynamic>).containsKey('StopId')) {
      stopId = doc['StopId'];
    }
    else {
      stopId = '';
    }

    if ((doc.data() as Map<String,dynamic>).containsKey('RouteId')) {
      routeId = doc['RouteId'] ?? '';
    }
    else {
      routeId = '';
    }

    if ((doc.data() as Map<String,dynamic>).containsKey('Order')) {
      order = doc['Order'];
    }
    else {
      order = -1;
    }

    return RouteStop(
      id: doc.id,
      order: order,
      stopId: stopId,
      routeId: routeId,
    );
  }

  List<RouteStop> _routeStopsFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) => (
        createRouteStopInstance(doc)
      )).toList();
      
    } catch (e) {
      debugPrint('erro: $e');
      return [];
    }
  }
  
  Stream<List<RouteStop>> get routeStops {
    return routeStopCollection.snapshots()
      .map(_routeStopsFromSnapshot);
  }

}