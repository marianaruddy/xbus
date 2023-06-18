import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/vehicle.dart';

class VehicleService {
  final CollectionReference vehicleCollection = FirebaseFirestore.instance.collection('Vehicle');

  Vehicle createVehicleInstance(doc) {
    String licensePlate;
    int capacity;
    if ((doc.data() as Map<String, dynamic>).containsKey('LicensePlate')) {
      licensePlate = doc['LicensePlate'];
    } else {
      licensePlate = '';
    }
    if ((doc.data() as Map<String, dynamic>).containsKey('Capacity')) {
      capacity = doc['Capacity'];
    } else {
      capacity = 0;
    }
    return Vehicle(
      id: doc.id,
      licensePlate: licensePlate,
      capacity: capacity,
    );
  }

  List<Vehicle> _vehicleListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => (createVehicleInstance(doc))).toList();
  }

  Stream<List<Vehicle>> get vehicles {
    return vehicleCollection.snapshots().map(_vehicleListFromSnapshot);
  }

  DocumentReference? getVehicleRefById(String? id) {
    if (id != null) {
      return vehicleCollection.doc(id);
    }
    return null;
  }
}
