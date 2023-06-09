class Ticket {
  final String id;
  final DateTime? boardingHour;
  final bool? checked;
  final num? price;
  final String? stopId;

  Ticket ({ 
    required this.id, 
    this.boardingHour,
    this.checked,
    this.price,
    this.stopId,
  });
  
}