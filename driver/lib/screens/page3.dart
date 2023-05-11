import 'package:driver/models/route_stop.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Page3 extends StatefulWidget {
  String? routeId;
  Page3(this.routeId);

  @override
  State<Page3> createState() => _Page3State(routeId);
}

class _Page3State extends State<Page3> {
  String? routeId;
  _Page3State(this.routeId);
  @override
  Widget build(BuildContext context) {
    List<RouteStop> routeStops = Provider.of<List<RouteStop>?>(context) ?? [];
    routeStops.forEach((routeStop) {
      print('');
      print('routeStop?.id: ${routeStop?.id}');
      print('routeStop?.routeId: ${routeStop?.routeId}');
      print('routeStop?.stopId: ${routeStop?.stopId}');
      
    });
    List<RouteStop> thisRouteStops = routeStops.where((routeStop) => routeStop?.routeId == routeId).toList();
    print('----------------thisRouteStops:');
    thisRouteStops.sort((a, b) => a.order - b.order);
    thisRouteStops.forEach((routeStop) {
      print('[${routeStop?.order}]');
      print('routeStop?.id: ${routeStop?.id}');
      print('routeStop?.routeId: ${routeStop?.routeId}');
      
    });
    return Container(
      child: Column(
        children: thisRouteStops.map((routeStop) => (
          ElevatedButton(
            onPressed: () {
              print('passei pelo ponto ${routeStop.order.toString()}');
            },
            child: Text('ponto ${routeStop.order.toString()}'),
          )
        )).toList(),
      ),
    );
  }
}