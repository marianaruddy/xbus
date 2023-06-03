import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String id;
  final DateTime? boardingHour;
  final bool? checked;
  final num? price;
  final String? stopId;
  final DocumentReference? stopRef;

  Ticket ({ 
    required this.id, 
    this.boardingHour,
    this.checked,
    this.price,
    this.stopId,
    this.stopRef,
  });
  
}