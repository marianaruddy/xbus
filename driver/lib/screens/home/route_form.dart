import 'package:driver/models/route.dart';
import 'package:driver/models/stop.dart';
import 'package:driver/models/trip.dart';
import 'package:driver/models/vehicle.dart';
import 'package:driver/screens/navigation/navigation.dart';
import 'package:driver/screens/home/navigation_screen.dart';
import 'package:driver/services/trip.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:driver/shared/constants.dart';

class RouteForm extends StatefulWidget {
  final List<RouteModel?>? routes;
  final List<Vehicle>? licensePlates;
  final List<Trip>? trips;
  final List<Stop>? stops;
  const RouteForm(
    this.routes,
    this.licensePlates,
    this.trips,
    this.stops,
    {super.key}
  );

  @override
  State<RouteForm> createState() => _RouteFormState(routes, licensePlates, trips, stops);
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
  final List<RouteModel?>? routes;

  final List<Vehicle>? licensePlates;

  final List<Trip>? trips;

  final List<Stop>? stops;

  _RouteFormState(
    this.routes,
    this.licensePlates,
    this.trips,
    this.stops,
  );

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

    final formKey = GlobalKey<FormState>();

    final uid = FirebaseAuth.instance.currentUser?.uid;

    List<Vehicle>? availablelicensePlates = _currentHour != null
      ? licensePlates?.where((lcnsPlate) => (
          lcnsPlate.capacity >= (_currentHour?.capacityInVehicle as num)
        )).toList()
      : [];

    List<Trip>? selectedRoutesTrips = _currentRoute != null ? trips?.where((trip) => trip.routeId == _currentRoute?.id).toList() : [];
    startStop = _currentRoute != null
      ? stops?.firstWhere((stop) => stop.id == _currentRoute?.origin)
      : null;
    destinyStop = _currentRoute != null
      ? stops?.firstWhere((stop) => stop.id == _currentRoute?.destiny)
      : null;
    if (startStop != null) {
      setState(() {
        startLat = startStop?.coords.latitude;
        startLong = startStop?.coords.longitude;
      });
    } else {
    }

    if (destinyStop != null) {
      setState(() {
        destinyLat = destinyStop?.coords.latitude;
        destinyLong = destinyStop?.coords.longitude;
      });
    } else {
    }

    return Form(
      key: formKey,
      child: Expanded(
        child: Column(
          children: [
            const SizedBox(height: 20.0),

            (routes?.isNotEmpty ?? false) ? DropdownButtonFormField<RouteModel>(
              isExpanded: true,
              decoration: textInputDecoration.copyWith(hintText: 'Selecione uma rota'),
              value: _currentRoute,
              items: routes?.map((route) {
                Stop? currRouteStart = stops?.firstWhere((stop) => stop.id == route?.origin);
                Stop? currRouteDestiny = stops?.firstWhere((stop) => stop.id == route?.destiny);
                String optionLabel = 'Linha ${route?.number.toString()}: ${currRouteStart?.name} - ${currRouteDestiny?.name}';
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

            (selectedRoutesTrips?.isNotEmpty ?? false) ? DropdownButtonFormField<Trip>(
              isExpanded: true,
              decoration: textInputDecoration.copyWith(hintText: 'Selecione um horário'),
              value: _currentHour,
              items: selectedRoutesTrips?.map((hour) {
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
              _currentRoute != null
              ? const Text('Nenhum horário cadastrado')
              : Container()
            ),

            const SizedBox(height: 20.0),

            (availablelicensePlates?.isNotEmpty ?? false) ? DropdownButtonFormField<Vehicle>(
              isExpanded: true,
              decoration: textInputDecoration.copyWith(hintText: 'Selecione um veículo'),
              value: _currentLicensePlate,
              items: availablelicensePlates?.map((license) {
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
            ) : (
              _currentHour != null
              ? const Text('Nenhum veículo cadastrado')
              : Container()
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
                    'RouteId': _currentRoute?.id,
                    'VehicleId': _currentLicensePlate?.id,
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