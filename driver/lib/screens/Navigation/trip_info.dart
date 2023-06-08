import 'package:driver/models/route.dart';
import 'package:driver/models/stop.dart';
import 'package:driver/services/route.dart';
import 'package:driver/services/stops.dart';
import 'package:flutter/material.dart';

class TripInfo extends StatefulWidget {
  String routeId;
  TripInfo(this.routeId, {super.key});

  @override
  State<TripInfo> createState() => _TripInfoState(routeId);
}

class _TripInfoState extends State<TripInfo> {
  String? routeId;
  _TripInfoState(this.routeId);

  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> getData() async {
      RouteModel? route = await RouteService().getRouteInstanceById(routeId);

      String? originStopId = route?.origin;
      String? destinyStopId = route?.destiny;

      Stop? originStop = await StopService().getStopInstanceById(originStopId);
      Stop? destinyStop = await StopService().getStopInstanceById(destinyStopId);

      Map<String, dynamic> data = {
        "route": route,
        "originStop": originStop,
        "destinyStop": destinyStop,
      }; 
      return data;
    }

    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          RouteModel? route = snapshot.data!['route'];
          Stop? originStop = snapshot.data!['originStop'];
          Stop? destinyStop = snapshot.data!['destinyStop'];

          return Text(
            'Linha ${route?.number}: ${originStop?.name} - ${destinyStop?.name}',
            style: const TextStyle(fontSize: 20)
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(
            '...',
            style: TextStyle(fontSize: 20)
          );
        }
        else {
          return const Text(
            '[ERRO]',
            style: TextStyle(fontSize: 20)
          );
        }
      },
    );
  }
}