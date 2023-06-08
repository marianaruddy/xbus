import 'package:cloud_firestore/cloud_firestore.dart';

class DriverService {
  final CollectionReference driverCollection = FirebaseFirestore.instance.collection('Driver');

  Future updateDriver(
    String uid,
    String? email,
    String? company,
    String? document,
    String? name,
    String? photo
  ) async {
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
}
