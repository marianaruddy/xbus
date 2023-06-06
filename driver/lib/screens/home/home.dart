import 'package:driver/models/stop.dart';
import 'package:driver/models/trip.dart';
import 'package:driver/models/vehicle.dart';
import 'package:driver/screens/home/route_form.dart';
import 'package:driver/services/auth.dart';
import 'package:driver/services/database.dart';
import 'package:driver/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return 
      MultiProvider(providers: [
        StreamProvider<List<RouteModel>?>.value(
          value: DatabaseService().routes,
          initialData: null,
        ),
        StreamProvider<List<Vehicle>?>.value(
          value: DatabaseService().vehicles,
          initialData: null,
        ),
        StreamProvider<List<Trip>?>.value(
          value: DatabaseService().trips,
          initialData: null,
        ),
        StreamProvider<List<Stop>?>.value(
          value: DatabaseService().stops,
          initialData: null,
        ),
      ],
      child: Scaffold(
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
              child: loading ? Loading() : Column(
                children: const [
                  RouteForm(),
                ],
              ),
            ),
          ),
        ),
    );
  }
}