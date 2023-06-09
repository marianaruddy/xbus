import 'package:cloud_firestore/cloud_firestore.dart';

class Stop {
  final String id;
  final String address;
  final GeoPoint coords;
  final String name;
  final String regionId;

  Stop ({
    required this.id,
    required this.address,
    required this.coords,
    required this.name,
    required this.regionId,
  });
  
}