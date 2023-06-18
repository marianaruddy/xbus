import 'package:driver/models/trip.dart';
import 'package:driver/screens/navigation/stops_list.dart';
import 'package:driver/screens/home/home.dart';
import 'package:driver/screens/qrcode/scan.dart';
import 'package:driver/services/trip.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  Trip? selectedTrip;
  Navigation(
    this.selectedTrip,
    {super.key}
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
    Future openConfirmModal(context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Deseja realmente finalizar a viagem atual?"),
        actions: [
          TextButton(
            onPressed: () => {
              Navigator.of(context).pop()
              },
            child: const Text('Cancelar')
          ),
          TextButton(
            onPressed: () async => {
              await TripService().updateTrip(
                selectedTrip?.id,
                {
                  'ActualArrivalTime': DateTime.now(),
                }
              ),
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const Home()
              ))
            },
            child: const Text('Finalizar')
          ),
        ],
      ));

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
                    openConfirmModal(context);
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
                      builder: (context) => ScanQRCode(selectedTrip?.id),
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