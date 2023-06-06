import 'package:cloud_firestore/cloud_firestore.dart';

class Stop {
  final String id;
  final String address;
  final String name;
  final String regionId;
  final GeoPoint coord;

  Stop ({
    required this.id,
    required this.address,
    required this.name,
    required this.regionId,
    required this.coord,
  });
  
}