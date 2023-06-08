import 'package:driver/models/current_trip.dart';
import 'package:driver/models/route.dart';
import 'package:driver/models/route_stop.dart';
import 'package:driver/screens/home/route_form.dart';
import 'package:driver/screens/navigation/stop_list_item.dart';
import 'package:driver/services/current_trip.dart';
import 'package:driver/services/route.dart';
import 'package:driver/shared/loading.dart';
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
  Future<RouteModel?>? routeRef;

  @override
  Widget build(BuildContext context) {
    CurrentTrip? currentTrip;
    List<RouteStop> routeStops = Provider.of<List<RouteStop>?>(context) ?? [];
    List<CurrentTrip> currentTrips = Provider.of<List<CurrentTrip>?>(context) ?? [];
    
    List<RouteStop> thisRouteStops = routeStops.where((routeStop) {
      return routeStop.routeId == routeId;
    }).toList();
    List<CurrentTrip> currentTripsThisTrip = currentTrips.where((currentTrips) {
      return currentTrips.tripId == tripId;
    }).toList();

    val = currentTripsThisTrip.map((currTrip) => currTrip.actualTime != null).toList();

    thisRouteStops.sort((a, b) => a.order - b.order);

    return FutureBuilder(
      future: RouteService().getRouteInstanceById(routeId),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          RouteModel? route = snapshot.data;
          return SingleChildScrollView(
            child: Column(
              children: [
                Text('Linha: ${route?.number}'),
                Text('tripId: $tripId'),
                ...thisRouteStops.map((routeStop) {
                  String intendedTime = formatDateTime2DateAndTimeString(currentTrip?.intendedTime ?? DateTime.now()).split(' ')[0];
                  return Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          value: val[routeStop.order-1],
                          onChanged: (bool? value) {
                            currentTrip = currentTripsThisTrip.firstWhere((currTrip) => 
                              currTrip.stopId == routeStop.stopId
                            );
                            CurrentTripService().updateCurrentTrip(
                              currentTrip?.id,
                              {
                                'ActualTime': value! ? DateTime.now() : null,
                              }
                            );
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          title: StopListItem(routeStop.stopId, intendedTime)
                        ),
                      )
                    ],
                  );
                }).toList()
              ],
            ),
          );
        }
        else {
          return Loading();
        }
      }, 
    );
  }
}