import 'package:driver/models/trip.dart';
import 'package:driver/screens/navigation/stops_list.dart';
import 'package:driver/screens/home/home.dart';
import 'package:driver/screens/qrcode/scan_qrcode_wrapper.dart';
import 'package:driver/services/trip.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  Trip? selectedTrip;
  Navigation(
    this.selectedTrip
  );

  @override
  State<Navigation> createState() => _NavigationState(selectedTrip);
}

class _NavigationState extends State<Navigation> {
  Trip? selectedTrip;
  _NavigationState(
    this.selectedTrip
  );

  double startLat = -22.979242;
  double startLong = -43.231765;
  double destinyLat = -22.947481;
  double destinyLong = -43.182599;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: const Text('xBus'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: StopsList(selectedTrip?.routeId, selectedTrip?.id),
                ),
              ]
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Tooltip(
                message: 'Finalizar Viagem',
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15.0),
                  ),
                  onPressed: () {
                    TripService().updateTrip(
                    selectedTrip?.id,
                    {
                      'ActualArrivalTime': DateTime.now(),
                    }
                  );
                  Navigator.of(context)
                    .push(
                      MaterialPageRoute(builder: (context) => const Home())
                    );
                  },
                  child: const Icon(
                    Icons.flag,
                    size: 40.0,
                  ),
                ),
              ),
              Tooltip(
                message: 'Escanear ticket',
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ScanQRCodeWrapper(selectedTrip?.id),
                    ));
                  },
                  child: const Icon(
                    Icons.qr_code_scanner,
                    size: 40.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}