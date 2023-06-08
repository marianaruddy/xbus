import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver/models/user.dart';
import 'package:flutter/material.dart';

class AuthService {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      Driver? driver = _userFromFirebaseUser(user); 
      FirebaseFirestore.instance.collection('Driver').doc(result.user?.uid).set({
        'Id': result.user?.uid,
        'Email': email,
        'Company': null,
        'Document': null,
        'Name': null,
        'Photo': null,
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