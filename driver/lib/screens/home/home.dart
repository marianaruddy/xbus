import 'package:driver/models/vehicle.dart';
import 'package:driver/screens/home/route_form.dart';
import 'package:driver/services/auth.dart';
import 'package:driver/services/database.dart';
import 'package:driver/shared/constants.dart';
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

  // TODO: get data from firebase
  final List<String> hours = ['9:00', '10:00', '11:00', '12:00'];

  String? currentHour;

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
      ],
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: Text('xbus'),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  title: Text('sair'),
                  leading: Icon(Icons.logout, color: Colors.green),
                  onTap: () async {
                    await _auth.signOut();
                  },
                )
              ],
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: loading ? Loading() : Column(
                children: [
                  RouteForm(),
                  SizedBox(height: 20.0),
                  hours.length > 0 ? DropdownButtonFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Selecione um horário'),
                    value: currentHour,
                    items: hours.map((hour) {
                      return DropdownMenuItem(
                        value: hour,
                        child: Text(hour),
                      );
                    }).toList(), 
                    onChanged: (value) { setState(() => currentHour = value); },
                  ) : 
                  Text('Nenhum horário cadastrado'),
                  SizedBox(height: 20.0),
    
                  // TODO: add google maps integration
    
                  // // TODO: image not working
                  // Image.asset(
                  //   'assets/map.png',
                  //   fit: BoxFit.contain,
                  // ),
    
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      print('currentHour');
                      print(currentHour);
                    },
                    child: Text('Iniciar Viagem'),
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}