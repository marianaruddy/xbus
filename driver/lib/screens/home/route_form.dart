import 'package:driver/models/route.dart';
import 'package:driver/models/trip.dart';
import 'package:driver/models/vehicle.dart';
import 'package:driver/screens/Page2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver/shared/constants.dart';
import 'package:driver/services/database.dart';

class RouteForm extends StatefulWidget {
  const RouteForm({super.key});

  @override
  State<RouteForm> createState() => _RouteFormState();
}

String formatNumberTo2digits(int number) {
  return (number < 10 ? '0${number}' : number).toString();
}

String formatDateTime2DateAndTimeString(DateTime original) {
  String hr = formatNumberTo2digits(original.hour);
  String min = formatNumberTo2digits(original.minute);
  
  String day = formatNumberTo2digits(original.day);
  String month = formatNumberTo2digits(original.month);
  String year = '${original.year}';

  String time = '$hr:$min';
  String date = '$day/$month/$year';
  
  return '$time - $date';
}

class _RouteFormState extends State<RouteForm> {
  RouteModel? _currentRoute;

  Vehicle? _currentLicensePlate;

  Trip? _currentHour;
    
  @override
  Widget build(BuildContext context) {

    final routes = Provider.of<List<RouteModel>?>(context) ?? [];

    final licensePlates = Provider.of<List<Vehicle>?>(context) ?? [];

    final trips = Provider.of<List<Trip>?>(context) ?? [];
  
    final _formKey = GlobalKey<FormState>();
  
    return Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  routes.length > 0 ? DropdownButtonFormField<RouteModel>(
                    decoration: textInputDecoration.copyWith(hintText: 'Selecione uma rota'),
                    value: _currentRoute,
                    items: routes.map((route) {
                      return DropdownMenuItem(
                        value: route,
                        child: Text('Linha ${route.number.toString()}: ${route.origin} - ${route.destiny}'),
                      );
                    }).toList(), 
                    onChanged: (value) {
                      setState(() { _currentRoute = value; });
                    },
                  ) : 
                  Text('Nenhuma rota cadastrada'),
                  SizedBox(height: 20.0),
                  licensePlates.length > 0 ? DropdownButtonFormField<Vehicle>(
                    decoration: textInputDecoration.copyWith(hintText: 'Selecione um veículo'),
                    value: _currentLicensePlate,
                    items: licensePlates.map((license) {
                      return DropdownMenuItem(
                        value: license,
                        child: Text(license.licensePlate.toString()),
                      );
                    }).toList(), 
                    onChanged: (value) {
                      setState(() { _currentLicensePlate = value; });
                    },
                  ) : 
                  Text('Nenhum veículo cadastrado'),
                  SizedBox(height: 20.0),
                  trips.length > 0 ? DropdownButtonFormField<Trip>(
                    decoration: textInputDecoration.copyWith(hintText: 'Selecione um horário'),
                    value: _currentHour,
                    items: trips.map((hour) {
                      return DropdownMenuItem(
                        value: hour,
                        child: Text(formatDateTime2DateAndTimeString(hour.intendedDepartureTime)),
                      );
                    }).toList(), 
                    onChanged: (value) { 
                      setState(() { _currentHour = value; });
                    },
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
                      DatabaseService().updateTrip(
                        'uNmERZYMO878TnTCJcXB', //TODO: MUDAR AQUI
                        {
                          'ActualDepartureTime': DateTime.now(),
                        }
                      );
                      Navigator.of(context)
                        .push(
                          MaterialPageRoute(builder: (context) => Page2())
                        );
                    },
                    child: Text('Iniciar Viagem'),
                  )
                ],
              ),
            ),);
  }
}