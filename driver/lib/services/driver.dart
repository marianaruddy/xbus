import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/user.dart';

class DriverService {
  final CollectionReference driverCollection = FirebaseFirestore.instance.collection('Driver');

  Future updateDriver(
    String uid,
    String? email,
    String? company,
    String? document,
    String? name,
  ) async {
    FirebaseFirestore.instance.collection('Driver').doc(uid).update({
      'Email': email,
      'Company': company,
      'Document': document,
      'Name': name,
    });
  }

  DocumentReference? getDriverRefById(String? id) {
    if (id != null) {
      return driverCollection.doc(id);
    }
    return null;
  }

  Driver createDriverInstance (doc) {
    String? email;
    String? company;
    String? document;
    String? name;

    if ((doc.data() as Map<String, dynamic>).containsKey('Email')) {
      email = doc['Email'];
    } else {
      email = null;
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('Company')) {
      company = doc['Company'];
    } else {
      company = null;
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('Document')) {
      document = doc['Document'];
    } else {
      document = null;
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('Name')) {
      name = doc['Name'];
    } else {
      name = null;
    }

    return Driver(
      uid: doc.id,
      email: email,
      company: company,
      document: document,
      name: name,
    );
  }
}
