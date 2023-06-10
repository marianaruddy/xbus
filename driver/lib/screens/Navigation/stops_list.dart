import 'package:driver/models/current_trip.dart';
import 'package:driver/models/route_stop.dart';
import 'package:driver/models/trip.dart';
import 'package:driver/screens/home/route_form.dart';
import 'package:driver/screens/navigation/stop_list_item.dart';
import 'package:driver/screens/navigation/trip_info.dart';
import 'package:driver/services/current_trip.dart';
import 'package:driver/services/route_stops.dart';
import 'package:driver/services/trip.dart';
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
  int currentTripIndex = 0;

  @override
  Widget build(BuildContext context) {
    CurrentTrip? currentTrip;

    Future<Map<String, dynamic>> getData() async {
      List<CurrentTrip?> currentTripsThisTrip = await CurrentTripService().getCurrTripsFromTrip(tripId);
      List<RouteStop>? thisRouteStops = await RouteStopsService().getRouteStopsFromRoute(routeId);
      Trip? trip = await TripService().getTripInstaceFromId(tripId);
      Map<String, dynamic> data = {
        "currentTripsThisTrip": currentTripsThisTrip,
        "thisRouteStops": thisRouteStops,
        "trip": trip,
      };

      return data;
    }

    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<CurrentTrip?>? currentTripsThisTrip = snapshot.data!['currentTripsThisTrip'];
          List<RouteStop>? thisRouteStops = snapshot.data!['thisRouteStops'];
          Trip? trip = snapshot.data!['trip'];

          for (var i = 0; i < thisRouteStops!.length; i++) {
            bool element = currentTripsThisTrip!.firstWhere((currTtip) => (
              thisRouteStops[i].stopId == currTtip?.stopId
            ))?.actualTime != null;
            val.insert(i, element);
          }
          currentTrip = currentTripsThisTrip?[currentTripIndex];

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30.0),

                TripInfo(routeId!),

                if ((peopleInBus ?? -1) > 0) ...[
                  const SizedBox(height: 10.0),
                  // Text('pessoas no ônibus: $peopleInBus'),
                ]
                else ...[
                  const SizedBox(height: 10.0),
                  Text('pessoas no ônibus: 10'),
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
                    child: Container(),
                  ),
                ),
                ...thisRouteStops.map((routeStop) {
                  return Row(
                    children: [
                      Column(
                        children: [
                          if(currentTripIndex==routeStop.order-1) ...[
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top:8.0),
                                  child: const Text(
                                    'PRóXIMA PARADA:',
                                    style: TextStyle(fontSize: 10.0),
                                  ),
                                ),
                                Row(
                                  children: [
                                    StopListItem(routeStop.stopId, '00:00'),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if(currentTripIndex <= (currentTripsThisTrip?.length ?? -2)) {
                                            currentTrip = currentTripsThisTrip?[currentTripIndex];
                                            currentTripIndex += 1;
                                          }
                                        });
                                        CurrentTripService().updateCurrentTrip(
                                          currentTrip?.id,
                                          {
                                            'ActualTime': DateTime.now(),
                                          }
                                        );
                                      },
                                      child: const Text('PONTO VISITADO'),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ]
                          else ...[
                            StopListItem(routeStop.stopId, '00:00'),
                          ]
                        ],
                      ),
                    ],
                  );
                }),
                // TODO: tirar esse botao daqui
                        ElevatedButton(
                          onPressed: () {
                              setState(() {
                                currentTripIndex=0;
                              });
                            },
                          child: const Text('zerar (tirar esse botao daqui)'),
                        )
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