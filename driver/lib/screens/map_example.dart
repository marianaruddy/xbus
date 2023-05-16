import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMap extends StatefulWidget {
  double? startLat;
  double? startLong;
  double? destinyLat;
  double? destinyLong;
  MyMap(this.destinyLat, this.destinyLong, this.startLat, this.startLong);

  @override
  _MyMapState createState() => _MyMapState(destinyLat, destinyLong, startLat, startLong);
}

class _MyMapState extends State<MyMap> {
  double? startLat;
  double? startLong;
  double? destinyLat;
  double? destinyLong;
  _MyMapState(this.destinyLat, this.destinyLong, this.startLat, this.startLong);

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-22.9797462, -43.2382729);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final List<Marker> _markers = <Marker>[];

  @override
  Widget build(BuildContext context) {
    LatLng initLatLng = LatLng(startLat ?? 0.0, startLong ?? 0.0); 
    Marker startMarker = Marker(
      markerId: MarkerId('($startLat, $startLong)'),
      position: LatLng(startLat ?? 0.0, startLong ?? 0.0),
      infoWindow: InfoWindow(
        title: 'Start ($startLat, $startLong)',
      ),
      icon: BitmapDescriptor.defaultMarker,
    );
    _markers.add(
      startMarker
    );
    Marker destinyMarker = Marker(
      markerId: MarkerId('($destinyLat, $destinyLong)'),
      position: LatLng(destinyLat ?? 0.0, destinyLong ?? 0.0),
      infoWindow: InfoWindow(
        title: 'destiny ($destinyLat, $destinyLong)',
      ),
      icon: BitmapDescriptor.defaultMarker,
    );
    _markers.add(
      destinyMarker
    );

    return GoogleMap(
      onMapCreated: _onMapCreated,
      markers: Set<Marker>.of(_markers),
      initialCameraPosition: CameraPosition(
        target: initLatLng,
        zoom: 11.0,
      ),
    );
  }
}