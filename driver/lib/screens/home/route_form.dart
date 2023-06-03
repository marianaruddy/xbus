import 'package:driver/models/route.dart';
import 'package:driver/models/trip.dart';
import 'package:driver/models/vehicle.dart';
import 'package:driver/screens/Navigation/navigation.dart';
import 'package:driver/screens/navigation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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

Future<List> getGeoCoderData(address) async {
  List<Location> locations =
    await locationFromAddress(address);
  
  return [locations.first.latitude, locations.first.longitude];
}

class _RouteFormState extends State<RouteForm> {
  RouteModel? _currentRoute;

  Vehicle? _currentLicensePlate;

  Trip? _currentHour;
    
  Trip? _selectedHour;
    double? startLat;
    double? startLong;
    double? destinyLat;
    double? destinyLong;

  @override
  Widget build(BuildContext context) {

    final routes = Provider.of<List<RouteModel>?>(context) ?? [];

    final licensePlates = Provider.of<List<Vehicle>?>(context) ?? [];

    final trips = Provider.of<List<Trip>?>(context) ?? [];
  
    final _formKey = GlobalKey<FormState>();

    final uid = FirebaseAuth.instance.currentUser?.uid;

    List<Trip> selectedRoutesTrips = _currentRoute != null ? trips.where((trip) => trip.routeId == _currentRoute?.id).toList() : [];
  
    double startLat = -22.979242;
    double startLong = -43.231765;
    double destinyLat = -22.947481;
    double destinyLong = -43.182599;
  
    return Container(
            child: Form(
              key: _formKey,
              child: Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    routes.isNotEmpty ? DropdownButtonFormField<RouteModel>(
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
                        if (value?.origin != null){
                          getGeoCoderData(_currentRoute?.origin).then((location) => {
                            setState(() { startLat = location.elementAt(0); }),
                            setState(() { startLong = location.elementAt(1); })
                          }).then((value) => print('set value: ${startLat.toString()}'));
                          
                        }
                        if (value?.destiny != null){
                          getGeoCoderData(_currentRoute?.destiny).then((location) => {
                            setState(() { destinyLat = location.elementAt(0); }),
                            setState(() { destinyLong = location.elementAt(1); })
                          }).then((value) => print('set value: ${destinyLat.toString()}'));
                          
                        }
                      },
                    ) : 
                    Text('Nenhuma rota cadastrada'),
                    SizedBox(height: 20.0),
                    licensePlates.isNotEmpty ? DropdownButtonFormField<Vehicle>(
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
                    selectedRoutesTrips.isNotEmpty ? DropdownButtonFormField<Trip>(
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
                    if (startLat!=null && startLong!=null && destinyLat!=null && destinyLong!=null) ...[
                      Expanded(
                        // child: MyMap(destinyLat, destinyLong, startLat, startLong),
                        child: NavigationScreen(startLat ?? 0.0, startLong ?? 0.0, destinyLat ?? 0.0, destinyLong ?? 0.0, false),
                      ),
                    ],
                    
                  
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: (_currentHour == null || _currentLicensePlate == null || _currentRoute == null)
                        ? null
                        : () {
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