import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/route.dart';

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

}