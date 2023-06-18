import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/services/trip.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationUpdater extends StatefulWidget {
  String? tripId;
  LocationUpdater(this.tripId, {super.key});

  @override
  State<LocationUpdater> createState() => _LocationUpdaterState(tripId);
}

class _LocationUpdaterState extends State<LocationUpdater> {
  String? tripId;
  _LocationUpdaterState(this.tripId);
  LocationData? _currentLocation;
  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> getCurrentLocation () async {
    if(tripId != null) {
      Location location = Location();

      _currentLocation = await location.getLocation();

      location.onLocationChanged.listen((newLoc) {
        _currentLocation = newLoc;
        setState(() {});
        latitude = _currentLocation?.latitude ?? 0.0;
        longitude = _currentLocation?.longitude ?? 0.0;

        TripService().updateTrip(
          tripId,
          {
            'CurrentLocation': GeoPoint(latitude, longitude),
          }
        );

      });
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}