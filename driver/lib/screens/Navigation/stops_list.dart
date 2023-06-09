import 'package:driver/models/current_trip.dart';
import 'package:driver/models/route.dart';
import 'package:driver/models/route_stop.dart';
import 'package:driver/screens/home/route_form.dart';
import 'package:driver/screens/navigation/stop_list_item.dart';
import 'package:driver/screens/navigation/trip_info.dart';
import 'package:driver/services/current_trip.dart';
import 'package:driver/services/route_stops.dart';
import 'package:driver/shared/loading.dart';
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
  int? peopleInBus;
  Future<RouteModel?>? routeRef;
  int firstUnmarkedIndex=-1;

  @override
  Widget build(BuildContext context) {
    CurrentTrip? currentTrip;

    Future<Map<String, dynamic>> getData() async {
      List<CurrentTrip?> currentTripsThisTrip = await CurrentTripService().getCurrTripsFromTrip(tripId);
      List<RouteStop>? thisRouteStops = await RouteStopsService().getRouteStopsFromRoute(routeId);

      Map<String, dynamic> data = {
        "currentTripsThisTrip": currentTripsThisTrip,
        "thisRouteStops": thisRouteStops,
      };

      return data;
    }

    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<CurrentTrip?>? currentTripsThisTrip = snapshot.data!['currentTripsThisTrip'];
          List<RouteStop>? thisRouteStops = snapshot.data!['thisRouteStops'];

          for (var i = 0; i < thisRouteStops!.length; i++) {
            bool element = currentTripsThisTrip!.firstWhere((currTtip) => (
              thisRouteStops[i].stopId == currTtip?.stopId
            ))?.actualTime != null;
            val.insert(i, element);
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30.0),

                TripInfo(routeId!),

                if ((peopleInBus ?? -1) > 0) ...[
                  const SizedBox(height: 10.0),
                  Text('pessoas no ônibus: $peopleInBus'),
                ],

                const SizedBox(height: 20.0),
                FractionallySizedBox(
                  widthFactor: 1.0,
                  child: Container(
                    padding: const EdgeInsets.only(top: 10.0, left: 16.0, bottom: 10.0),
                    margin: const EdgeInsets.only(left: 0.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.green)
                      ),
                    ),
                    child: const Text(
                      'Marque os pontos já visitados:',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),

                ...(thisRouteStops.map((routeStop) {
                  currentTrip = currentTripsThisTrip?.firstWhere((currTrip) => 
                    currTrip?.stopId == routeStop.stopId
                  );
                  firstUnmarkedIndex = val.indexWhere((element) => element == false);
                  String intendedTime = formatDateTime2DateAndTimeString(currentTrip?.intendedTime ?? DateTime.now()).split(' ')[0];

                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            if(firstUnmarkedIndex == routeStop.order-1) ...[
                              const FractionallySizedBox(
                                widthFactor: 1.0,
                                child:  Padding(
                                  padding: EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    'PRóXIMA PARADA:',
                                    style: TextStyle(fontSize: 8.0),
                                  ),
                                ),
                              )
                            ],
                            CheckboxListTile(
                              value: val[routeStop.order-1],
                              onChanged: (bool? value) {
                                setState(() {
                                  currentTrip = currentTripsThisTrip?.firstWhere((currTrip) => 
                                    currTrip?.stopId == routeStop.stopId
                                  );
                                  peopleInBus = currentTrip?.passengersQtyAfter;
                                });
                                CurrentTripService().updateCurrentTrip(
                                  currentTrip?.id,
                                  {
                                    'ActualTime': value! ? DateTime.now() : null,
                                  }
                                );
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              title: StopListItem(routeStop.stopId, intendedTime),
                            ),
                          ]
                        ),
                      ),
                    ],
                  );
                })).toList()
              ],
            ),
          );
        }
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }
        else {
          return const Text('[ERRO]');
        }
      },
    );
  }
}