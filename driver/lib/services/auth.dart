import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/services/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver/models/user.dart';
import 'package:flutter/material.dart';

class AuthService {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference driverCollection = DriverService().driverCollection;

  Driver? _userFromFirebaseUser(User? user) {
    return user != null ? Driver(uid: user.uid): null;
  }
  
  Stream<Driver?> get user {
    return _auth.authStateChanges()
      .map(_userFromFirebaseUser);
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future createPasswordForDriver(String document, String password) async {
    try {
      List<Driver?> driverList = await driverCollection.where(
          'Document',
          isEqualTo: document,
        ).get().then((snapshot) {
          return snapshot.docs.map((doc) {
            if (doc.exists) {
              return DriverService().createDriverInstance(doc);
            }
            else {
              return null;
            }
          }).toList();
        });

      if (driverList.isNotEmpty) {
        Driver? driver = driverList.first;
        String? email = driver?.email;
        if (email != null) {
          UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
          return result;
        }
        else {
          throw Exception('No email');
        }
      }
      else {
        throw Exception('No driver registered');
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      Driver? driver = _userFromFirebaseUser(user); 
      driverCollection.doc(result.user?.uid).set({
        'Id': result.user?.uid,
        'Email': email,
        'Company': null,
        'Document': null,
        'Name': null,
      });
      return driver;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}