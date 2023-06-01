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
  List<bool> val = [];
  @override
  Widget build(BuildContext context) {
    List<RouteStop> routeStops = Provider.of<List<RouteStop>?>(context) ?? [];
    List<CurrentTrip> currentTrips = Provider.of<List<CurrentTrip>?>(context) ?? [];
    
    List<RouteStop> thisRouteStops = routeStops.where((routeStop) => routeStop?.routeId == routeId).toList();
    List<CurrentTrip> currentTripsThisTrip = currentTrips.where((currentTrips) => currentTrips?.tripId == tripId).toList();
    // val = List.generate(thisRouteStops[thisRouteStops.length-1].order, (index) => false);
    val = currentTripsThisTrip.map((currTrip) => currTrip.actualTime != null).toList();
    thisRouteStops.sort((a, b) => a.order - b.order);
    String? currentTripId;

    return Container(
      child: SingleChildScrollView (
        child: Column(
          children: [
            Text('routeId: $routeId'),
            Text('tripId: $tripId'),
            ...thisRouteStops.map((routeStop) {
              return Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      value: val[routeStop.order-1],
                      onChanged: (bool? value) {
                         currentTripId = currentTripsThisTrip.firstWhere((currTrip) => 
                          currTrip.stopId == routeStop.stopId
                        ).id;
                        DatabaseService().updateCurrentTrip(
                          currentTripId,
                          {
                            'ActualTime': DateTime.now(),
                          }
                        );
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text('ponto ${routeStop.stopId.toString()} [${routeStop.order-1}]'),
                    ),
                  )
                ],
              );
          }).toList()],
        ),
      ),
    );
  }
}