import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/vehicle.dart';

class VehicleService {
  final CollectionReference vehicleCollection = FirebaseFirestore.instance.collection('Vehicle');

  Vehicle createVehicleInstance(doc) {
    String licensePlate;
    bool active;
    int capacity;

    if ((doc.data() as Map<String, dynamic>).containsKey('LicensePlate')) {
      licensePlate = doc['LicensePlate'];
    } else {
      licensePlate = '';
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('Active')) {
      active = doc['Active'];
    } else {
      active = false;
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('Capacity')) {
      capacity = doc['Capacity'];
    } else {
      capacity = 0;
    }
    return Vehicle(
      id: doc.id,
      active: active,
      licensePlate: licensePlate,
      capacity: capacity,
    );
  }

  List<Vehicle> _vehicleListFromSnapshot(QuerySnapshot snapshot) {
    List<Vehicle> allVehicles = snapshot.docs.map((doc) => (
      createVehicleInstance(doc)
    )).toList();
    return allVehicles.where(((vehicle) => vehicle.active == true)).toList();
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
