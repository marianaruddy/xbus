import 'package:driver/models/current_trip.dart';
import 'package:driver/models/route_stop.dart';
import 'package:driver/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class StopsList extends StatefulWidget {
  String? routeId, tripId;
  StopsList(this.routeId, this.tripId, {super.key});

  @override
  State<StopsList> createState() => _StopsListState(routeId, tripId);
}

class _StopsListState extends State<StopsList> {
  String? routeId, tripId;
  _StopsListState(this.routeId, this.tripId);
  List<bool> val = [];
  @override
  Widget build(BuildContext context) {
    List<RouteStop> routeStops = Provider.of<List<RouteStop>?>(context) ?? [];
    List<CurrentTrip> currentTrips = Provider.of<List<CurrentTrip>?>(context) ?? [];
    
    List<RouteStop> thisRouteStops = routeStops.where((routeStop) => routeStop?.routeId == routeId).toList();
    List<CurrentTrip> currentTripsThisTrip = currentTrips.where((currentTrips) => currentTrips?.tripId == tripId).toList();

    val = currentTripsThisTrip.map((currTrip) => currTrip.actualTime != null).toList();

    thisRouteStops.sort((a, b) => a.order - b.order);
    String? currentTripId;
    CurrentTrip? currentTrip;

    return SingleChildScrollView (
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
                      currentTrip = currentTripsThisTrip.firstWhere((currTrip) => 
                        currTrip.stopId == routeStop.stopId
                      );
                      DatabaseService().updateCurrentTrip(
                        currentTrip?.id,
                        {
                          'ActualTime': value! ? DateTime.now() : null,
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
    );
  }
}