import 'package:driver/screens/home/navigation_drawer_widget.dart';
import 'package:driver/services/auth.dart';
import 'package:driver/shared/constants.dart';
import 'package:driver/shared/loading.dart';
import 'package:flutter/material.dart';

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
  final List<String> licensePlates = ['abc1234', 'xyz1234'];

  String? currentLicensePlate;

  // TODO: get data from firebase
  final List<String> routes = ['PUC - Leblon', 'PUC - Copacabana'];

  String? currentRoute;

  // TODO: get data from firebase
  final List<String> hours = ['9:00', '10:00', '11:00', '12:00'];

  String? currentHour;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
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
            child: Column(
              children: [
                SizedBox(height: 20.0),
                licensePlates.length > 0 ? DropdownButtonFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Selecione um veículo'),
                  value: currentLicensePlate,
                  items: licensePlates.map((license) {
                    return DropdownMenuItem(
                      value: license,
                      child: Text(license),
                    );
                  }).toList(), 
                  onChanged: (value) { setState(() => currentLicensePlate = value); },
                ) : 
                Text('Nenhum veículo cadastrado'),
                SizedBox(height: 20.0),
                routes.length > 0 ? DropdownButtonFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Selecione uma rota'),
                  value: currentRoute,
                  items: routes.map((route) {
                    return DropdownMenuItem(
                      value: route,
                      child: Text(route),
                    );
                  }).toList(), 
                  onChanged: (value) { setState(() => currentRoute = value); },
                ) : 
                Text('Nenhuma rota cadastrada'),
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
                    print('currentLicensePlate');
                    print(currentLicensePlate);
                    print('currentRoute');
                    print(currentRoute);
                    print('currentHour');
                    print(currentHour);
                  },
                  child: Text('Iniciar Viagem'),
                )
              ],
            ),
          ),
        ),
      );
  }
}