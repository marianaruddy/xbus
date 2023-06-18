class RouteModel {

  final String id;
  final String destiny;
  final int number;
  final String origin;
  final num? price;

  RouteModel ({
    required this.id,
    required this.destiny,
    required this.number,
    required this.origin,
    this.price,
  });
  
}