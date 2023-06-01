import 'package:driver/models/current_trip.dart';
import 'package:driver/models/route_stop.dart';
import 'package:driver/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Page3 extends StatefulWidget {
  String? routeId, tripId;
  Page3(this.routeId, this.tripId);

  @override
  State<Page3> createState() => _Page3State(routeId, tripId);
}

class _Page3State extends State<Page3> {
  String? routeId, tripId;
  _Page3State(this.routeId, this.tripId);
  @override
  Widget build(BuildContext context) {
    List<RouteStop> routeStops = Provider.of<List<RouteStop>?>(context) ?? [];
    List<CurrentTrip> currentTrips = Provider.of<List<CurrentTrip>?>(context) ?? [];
    routeStops.forEach((routeStop) {
      // print('');
      // print('routeStop?.id: ${routeStop?.id}');
      // print('routeStop?.routeId: ${routeStop?.routeId}');
      // print('routeStop?.stopId: ${routeStop?.stopId}');
      
    });
    print('routeId: ${routeId}',);
    List<RouteStop> thisRouteStops = routeStops.where((routeStop) => routeStop?.routeId == routeId).toList();
    List<CurrentTrip> currentTripsThisTrip = currentTrips.where((currentTrips) => currentTrips?.tripId == tripId).toList();
    // print('----------------thisRouteStops:');
    thisRouteStops.sort((a, b) => a.order - b.order);
    print('lent ${currentTripsThisTrip.length}');
    currentTrips.forEach((currentTrip) {
      print('tripId: ${tripId}-----------');
      print('currentTrip.tripId: ${currentTrip.tripId}-----------');
      
    });
    thisRouteStops.forEach((routeStop) {
      print('[${routeStop?.order}]');
      print('routeStop?.id: ${routeStop?.id}');
      print('routeStop?.routeId: ${routeStop?.routeId}');
      
    });
    bool val = false;
    String? currentTripId = null;
    return Container(
      child: SingleChildScrollView (
        child: Column(
          children: [
            Text('routeId: $routeId'),
            Text('tripId: $tripId'),
            ...thisRouteStops.map((routeStop) => Row(
            children: [
              Checkbox(
                value: val,
                onChanged: (value) => {
                  currentTripId = currentTripsThisTrip.firstWhere((currTrip) => 
                    currTrip.stopId == routeStop.stopId
                  ).id,
                  DatabaseService().updateCurrentTrip(
                    currentTripId,
                    {
                      'ActualTime': DateTime.now(),
                    }
                  ),
                  setState(() => val = !val)
                },
                
              ),
              Text('ponto ${routeStop.stopId.toString()}')
            ],
          )).toList()],
        ),
      ),
    );
  }
}