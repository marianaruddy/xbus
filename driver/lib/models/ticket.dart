class Ticket {
  final String id;
  final bool? checked;
  final String currentTripId;
  final String? passangerId;
  final String? stopId;

  Ticket ({ 
    required this.id, 
    this.checked,
    required this.currentTripId,
    this.passangerId,
    this.stopId,
  });
  
}