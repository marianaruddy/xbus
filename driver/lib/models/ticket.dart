class Ticket {
  final String id;
  final bool? checked;
  final bool used;
  final bool active;
  final String currentTripId;
  final String? passangerId;
  final String? stopId;

  Ticket ({ 
    required this.id, 
    this.checked,
    required this.used,
    required this.active,
    required this.currentTripId,
    this.passangerId,
    this.stopId,
  });
  
}