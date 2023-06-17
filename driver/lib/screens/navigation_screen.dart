import 'dart:async';

import 'package:driver/config/google_maps_api_key.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' show cos, sqrt, asin;

class NavigationScreen extends StatefulWidget {
  final double destinyLat;
  final double destinyLng;
  final double startLat;
  final double startLng;
  bool showNavBtn;
  NavigationScreen(this.startLat, this.startLng, this.destinyLat, this.destinyLng, this.showNavBtn, {super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState(startLat, startLng, destinyLat, destinyLng, showNavBtn);
}

class _NavigationScreenState extends State<NavigationScreen> {
  final double destinyLat;
  final double destinyLng;
  final double startLat;
  final double startLng;
  bool showNavBtn = false;
  _NavigationScreenState(this.startLat, this.startLng, this.destinyLat, this.destinyLng, this.showNavBtn);
  final Completer<GoogleMapController?> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Location location = Location();
  Marker? sourcePosition, destinationPosition;
  LatLng curLocation = const LatLng(-22.979242, -43.231765);  // PUC
  LatLng startLocation = const LatLng(-22.979242, -43.231765);  // PUC
  StreamSubscription<loc.LocationData>? locationSubscription;

  @override
  void initState() {
    super.initState();
    getNavigation();
    addMarker();
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sourcePosition == null
        ? const Center(child: CircularProgressIndicator())
        : Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(polylines.values),
              initialCameraPosition: CameraPosition(
                target: startLocation,
                zoom: 16,
              ),
              markers: {sourcePosition!, destinationPosition!},
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              compassEnabled: true,
            ),
            if (showNavBtn) ...[
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.green
                  ),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.navigation_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await launchUrl(
                          Uri.parse(
                            'google.navigation:q=${widget.destinyLat}, ${widget.destinyLng}&key=$googleMapsApiKey'
                          )
                        );
                      },
                    ),
                  ),
                )
              )
            ]
          ],
        ),
    );
  }

  getNavigation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    final GoogleMapController? controller = await _controller.future;
    location.changeSettings(accuracy: loc.LocationAccuracy.high);
    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    if (permissionGranted == loc.PermissionStatus.granted) {
      startLocation = LatLng(startLat, startLng);
      locationSubscription = location.onLocationChanged.listen(
        (LocationData currentLocation) {
          controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(startLat, startLng),
            zoom: 16,
          )));
          if (mounted) {
            controller
                ?.showMarkerInfoWindow(MarkerId(sourcePosition!.markerId.value));
            setState(() {
              startLocation = LatLng(startLat, startLng);
              sourcePosition = Marker(
                markerId: MarkerId(currentLocation.toString()),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen
                  ),
                position:
                    LatLng(startLat, startLng),
                infoWindow: InfoWindow(
                    title: '${double.parse((
                      getDistance(
                        LatLng(widget.startLat, widget.startLng),
                        LatLng(widget.destinyLat, widget.destinyLng)
                      ).toStringAsFixed(2)
                    ))} km'
                      ),
              );
            });
            getDirections(LatLng(widget.startLat, widget.startLng), LatLng(widget.destinyLat, widget.destinyLng));
          }
        }
      );
    }
  }

  getDirections(LatLng start, LatLng dst) async {
    List<LatLng> polylineCoordinates = [];
    List<dynamic> points = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleMapsApiKey,
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(dst.latitude, dst.longitude),
      travelMode: TravelMode.driving
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        points.add({'lat': point.latitude, 'lng': point.longitude});
      });
    } else {
      debugPrint(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng>polylineCoordinates) {
    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.green,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }

   double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double getDistance(LatLng startposition, LatLng destposition) {
    return calculateDistance(
      startposition.latitude,
      startposition.longitude,
      destposition.latitude,
      destposition.longitude
    );
  }
  addMarker() {
    setState(() {
      sourcePosition = Marker(
        markerId: const MarkerId('source'),
        position: startLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
      destinationPosition = Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(widget.destinyLat, widget.destinyLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      );
    });
  }
}
