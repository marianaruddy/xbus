import 'package:driver/models/current_trip.dart';
import 'package:driver/models/route_stop.dart';
import 'package:driver/models/trip.dart';
import 'package:driver/screens/Navigation/stopsList.dart';
import 'package:driver/screens/home/home.dart';
import 'package:driver/screens/qrcode/scan_qrcode_wrapper.dart';
import 'package:driver/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Navigation extends StatefulWidget {
  Trip? selectedTrip;
  Navigation(
    this.selectedTrip
  );

  @override
  State<Navigation> createState() => _NavigationState(selectedTrip);
}

class RoundedNumber extends StatelessWidget {
  int number;
  String message;
  RoundedNumber(this.number, this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      width:50.0,
      height:50.0,
      alignment: Alignment.center,
      child: Tooltip(
        message: message,
        child: Text(
          '$number',
          style: TextStyle(
            color: Colors.white,
            fontSize: 34
          ),
        ),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
    );
  }
}

class _NavigationState extends State<Navigation> {
  Trip? selectedTrip;
  _NavigationState(
    this.selectedTrip
  );

  int peopleInBus = 10; // TODO pegar dados do firebase
  int peopleAtNextStop = 5; // TODO pegar dados do firebase

  
  double startLat = -22.979242;
  double startLong = -43.231765;
  double destinyLat = -22.947481;
  double destinyLong = -43.182599;


  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        StreamProvider<List<RouteStop>?>.value(
          value: DatabaseService().routeStops,
          initialData: null,
        ),
        StreamProvider<List<CurrentTrip>?>.value(
          value: DatabaseService().currentTrips,
          initialData: null,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: const Text('xBus'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundedNumber(peopleInBus, 'Pessoas atualmente no ônibus'),
                RoundedNumber(peopleAtNextStop, 'Pessoas esperando no próximo ponto'),
              ],
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Expanded(
                    child: StopsList(selectedTrip?.routeId, selectedTrip?.id),
                  )
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Tooltip(
                  message: 'Finalizar Viagem',
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(15.0),
                    ),
                    onPressed: () {
                      DatabaseService().updateTrip(
                      selectedTrip?.id,
                      {
                        'ActualArrivalTime': DateTime.now(),
                      }
                    );
                    Navigator.of(context)
                      .push(
                        MaterialPageRoute(builder: (context) => Home())
                      );
                    },
                    child: Icon(
                      Icons.flag,
                      size: 40.0,
                    ),
                  ),
                ),
                Tooltip(
                  message: 'Escanear ticket',
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(15.0),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ScanQRCodeWrapper(selectedTrip?.id),
                      ));
                    },
                    child: Icon(
                      Icons.qr_code_scanner,
                      size: 40.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}