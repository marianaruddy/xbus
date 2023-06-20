import 'package:driver/models/stop.dart';
import 'package:driver/models/trip.dart';
import 'package:driver/models/vehicle.dart';
import 'package:driver/screens/home/route_form.dart';
import 'package:driver/services/auth.dart';
import 'package:driver/services/route.dart';
import 'package:driver/services/stops.dart';
import 'package:driver/services/trip.dart';
import 'package:driver/services/vehicle.dart';
import 'package:driver/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:driver/models/route.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  List<RouteModel?>? routes;
  List<Vehicle>? licensePlates;
  List<Trip>? trips;
  List<Stop>? stops;

  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> getData() async {
      List<RouteModel?> routes = await RouteService().geAllActiveRoutes();
      List<Vehicle>? licensePlates = await VehicleService().geAllActiveVehicles();
      List<Trip>? trips = await TripService().geAllActiveTrips();
      List<Stop>? stops = await StopService().geAllStops();

      Map<String, dynamic> data = {
        "routes": routes,
        "licensePlates": licensePlates,
        "trips": trips,
        "stops": stops,
      };

      return data;
    }

    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          routes = snapshot.data!['routes'];
          licensePlates = snapshot.data!['licensePlates'];
          trips = snapshot.data!['trips'];
          stops = snapshot.data!['stops'];

          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: const Text('xBus'),
              centerTitle: true,
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const ListTile(
                    title: Text('xBus'),
                  ),
                  ListTile(
                    title: const Text('sair'),
                    leading: const Icon(Icons.logout, color: Colors.green),
                    onTap: () {
                      _auth.signOut().then((value) {
                    });
                    },
                  )
                ],
              ),
            ),
            body: Container(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: loading ? const Loading() : Column(
                  children: [
                    RouteForm(routes, licensePlates, trips, stops),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        } else {
          return const Text('[ERRO]');
        }
      },
    );
  }
}