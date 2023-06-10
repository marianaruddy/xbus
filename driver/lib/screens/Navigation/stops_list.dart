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
  int currentTripIndex = 0;

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
          currentTrip = currentTripsThisTrip?[currentTripIndex];

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
                    child: ListView(
                              shrinkWrap: true,
                              children: [
                                ...thisRouteStops.map((routeStop) {
                                  String? status;
                                  if(currentTripIndex==routeStop.order-1){
                                    status = 'next';
                                  }
                                  else if(currentTripIndex>=routeStop.order-1){
                                    status = 'passed';
                                  }
                                  return Container(
                                    height: 50.0,
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            if(status=='next')...[
                                              const Text(
                                                'PRóXIMO PONTO:',
                                                style: TextStyle(fontSize: 10.0),
                                              )
                                            ],
                                            StopListItem(routeStop.stopId, '00:00', status),
                                          ]
                                        ),
                                      ],
                                    ),
                                  );
                                })
                              ],
                            ),
                  ),
                ),

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
                                      child: const Text('IR PARA PRÓXIMO PONTO'),
                                    ),

                
                            
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