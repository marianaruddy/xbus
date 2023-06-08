import 'package:driver/models/route.dart';
import 'package:driver/models/stop.dart';
import 'package:driver/models/trip.dart';
import 'package:driver/models/vehicle.dart';
import 'package:driver/screens/navigation/navigation.dart';
import 'package:driver/services/driver.dart';
import 'package:driver/services/trip.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:driver/shared/constants.dart';
import 'package:driver/services/database.dart';
import 'package:collection/collection.dart';

class RouteForm extends StatefulWidget {
  const RouteForm({super.key});

  @override
  State<RouteForm> createState() => _RouteFormState();
}

String formatNumberTo2digits(int number) {
  return (number < 10 ? '0$number' : number).toString();
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
  
  Stop? startStop;
  
  Stop? destinyStop;
    
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

    final stops = Provider.of<List<Stop>?>(context) ?? [];

    final formKey = GlobalKey<FormState>();

    final uid = FirebaseAuth.instance.currentUser?.uid;

    List<Trip> selectedRoutesTrips = _currentRoute != null ? trips.where((trip) => trip.routeId == _currentRoute?.id).toList() : [];
    startStop = _currentRoute != null
      ? stops.firstWhereOrNull((stop) => stop.id == _currentRoute?.origin)
      : null;
    destinyStop = _currentRoute != null
      ? stops.firstWhereOrNull((stop) => stop.id == _currentRoute?.destiny)
      : null;
    if (startStop != null) {
      setState(() {
        startLat = startStop?.coord.latitude;
        startLong = startStop?.coord.longitude;
      });
    } else {
    }

    if (destinyStop != null) {
      setState(() {
        destinyLat = destinyStop?.coord.latitude;
        destinyLong = destinyStop?.coord.longitude;
      });
    } else {
    }

    return Form(
      key: formKey,
      child: Expanded(
        child: Column(
          children: [
            const SizedBox(height: 20.0),

            routes.isNotEmpty ? DropdownButtonFormField<RouteModel>(
              isExpanded: true,
              decoration: textInputDecoration.copyWith(hintText: 'Selecione uma rota'),
              value: _currentRoute,
              items: routes.map((route) {
                Stop? currRouteStart = stops.firstWhereOrNull((stop) => stop.id == route.origin);
                Stop? currRouteDestiny = stops.firstWhereOrNull((stop) => stop.id == route.destiny);
                String optionLabel = 'Linha ${route.number.toString()}: ${currRouteStart?.name} - ${currRouteDestiny?.name}';
                return DropdownMenuItem(
                  value: route,
                  child: Text(optionLabel,
                  overflow: TextOverflow.visible,
                ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() { 
                  _currentRoute = value;
                  _currentHour = null;
                 });
                if (value?.origin != null){
                  getGeoCoderData(_currentRoute?.origin).then((location) => {
                    setState(() { 
                      startLat = location.elementAt(0);
                      startLong = location.elementAt(1);
                     }),
                  });

                }
                if (value?.destiny != null){
                  getGeoCoderData(_currentRoute?.destiny).then((location) => {
                    setState(() { 
                      destinyLat = location.elementAt(0);
                      destinyLong = location.elementAt(1);
                     }),
                  });
                }
              },
            ) : 
            const Text('Nenhuma rota cadastrada'),

            const SizedBox(height: 20.0),

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
            const Text('Nenhum veículo cadastrado'),

            const SizedBox(height: 20.0),

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
              ? const Text('Selecione uma rota') 
              : const Text('Nenhum horário cadastrado')
            ),

            const SizedBox(height: 20.0),

            if (startLat != null && startLong != null && destinyLat != null && destinyLong != null) ...[
              Expanded(
                child: NavigationScreen(startLat!, startLong!, destinyLat!, destinyLong!, false),
              ),
            ],
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: (_currentHour == null || _currentLicensePlate == null || _currentRoute == null)
                ? null
                : () {
                _selectedHour = _currentHour;
                _currentHour = null;
                TripService().updateTrip(
                  _selectedHour?.id,
                  {
                    'ActualDepartureTime': DateTime.now(),
                    'ActualArrivalTime': null,
                    'DriverId': uid,
                    'DriverRef': DriverService().getDriverRefById(uid),
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
              child: const Text('Iniciar Viagem'),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}