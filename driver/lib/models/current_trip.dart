class CurrentTrip {
  final String id;
  final DateTime? actualTime;
  final DateTime intendedTime;
  final int capacityInVehicle;
  final int passengersQtyAfter;  
  final int passengersQtyBefore;  
  final int passengersQtyNew;  
  final String? stopId;
  final String? tripId;

  CurrentTrip ({
    required this.id,
    this.actualTime,
    required this.intendedTime,
    required this.capacityInVehicle,  
    required this.passengersQtyAfter, 
    required this.passengersQtyBefore,
    required this.passengersQtyNew,
    required this.stopId,
    required this.tripId,
  });

}