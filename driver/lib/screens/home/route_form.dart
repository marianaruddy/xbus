import 'package:driver/models/route.dart';
import 'package:driver/models/trip.dart';
import 'package:driver/models/vehicle.dart';
import 'package:driver/screens/Navigation/navigation.dart';
import 'package:driver/screens/navigation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    
  Trip? _selectedHour;

  @override
  Widget build(BuildContext context) {

    final routes = Provider.of<List<RouteModel>?>(context) ?? [];

    final licensePlates = Provider.of<List<Vehicle>?>(context) ?? [];

    final trips = Provider.of<List<Trip>?>(context) ?? [];
  
    final _formKey = GlobalKey<FormState>();

    final uid = FirebaseAuth.instance.currentUser?.uid;

    List<Trip> selectedRoutesTrips = _currentRoute != null ? trips.where((trip) => trip.routeId == _currentRoute?.id).toList() : [];
  
    double startLat = -22.9797462;
    double startLong = -43.2382729;
    double destinyLat = -22.947481;
    double destinyLong = -43.182599;
  
    return Container(
            child: Form(
              key: _formKey,
              child: Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    routes.length > 0 ? DropdownButtonFormField<RouteModel>(
                      isExpanded: true,
                      decoration: textInputDecoration.copyWith(hintText: 'Selecione uma rota'),
                      value: _currentRoute,
                      items: routes.map((route) {
                        return DropdownMenuItem(
                          value: route,
                          child: Text('Linha ${route.number.toString()}: ${route.origin} - ${route.destiny}',
                          overflow: TextOverflow.visible,
                        ),
                        );
                      }).toList(), 
                      onChanged: (value) {
                        setState(() { _currentRoute = value; });
                      },
                    ) : 
                    Text('Nenhuma rota cadastrada'),
                    SizedBox(height: 20.0),
                    licensePlates.length > 0 ? DropdownButtonFormField<Vehicle>(
                      isExpanded: true,
                      decoration: textInputDecoration.copyWith(hintText: 'Selecione um veículo'),
                      value: _currentLicensePlate,
                      items: licensePlates.map((license) {
                        return DropdownMenuItem(
                          value: license,
                          child: Text(license.licensePlate.toString(),
                            overflow: TextOverflow.visible,
                          ),
                        );
                      }).toList(), 
                      onChanged: (value) {
                        setState(() { _currentLicensePlate = value; });
                      },
                    ) : 
                    Text('Nenhum veículo cadastrado'),
                    SizedBox(height: 20.0),
                    selectedRoutesTrips.length > 0 ? DropdownButtonFormField<Trip>(
                      isExpanded: true,
                      decoration: textInputDecoration.copyWith(hintText: 'Selecione um horário'),
                      value: _currentHour,
                      items: selectedRoutesTrips.map((hour) {
                        return DropdownMenuItem(
                          value: hour,
                          child: Text(formatDateTime2DateAndTimeString(hour.intendedDepartureTime),
                            overflow: TextOverflow.visible,
                          ),
                        );
                      }).toList(), 
                      onChanged: (value) { 
                        setState(() { _currentHour = value; });
                      },
                    ) : (
                      _currentRoute == null
                      ? Text('Selecione uma rota') 
                      : Text('Nenhum horário cadastrado')
                    ),
                    SizedBox(height: 20.0),
                    Expanded(
                      child: NavigationScreen(startLat, startLong, destinyLat, destinyLong),
                    ),
                  
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        _selectedHour = _currentHour;
                        _currentHour = null;
                        DatabaseService().updateTrip(
                          _selectedHour?.id,
                          {
                            'ActualDepartureTime': DateTime.now(),
                            'ActualArrivalTime': null,
                            'DriverId': uid,
                            'DriverRef': DatabaseService().getDriverRefById(uid),
                            'RouteId': _currentRoute?.id,
                            'RouteRef': DatabaseService().getRouteRefById(_currentRoute?.id),
                            'VehicleId': _currentLicensePlate?.id,
                            'VehicleRef': DatabaseService().getVehicleRefById(_currentLicensePlate?.id),
                          }
                        );
                        Navigator.of(context)
                          .push(
                            MaterialPageRoute(builder: (context) => Navigation(_selectedHour))
                          );
                      },
                      child: Text('Iniciar Viagem'),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),);
  }
}