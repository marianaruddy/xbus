import 'package:driver/models/current_trip.dart';
import 'package:driver/models/ticket.dart';
import 'package:driver/screens/qrcode/scan_succeeded.dart';
import 'package:driver/screens/qrcode/scan_failed.dart';
import 'package:driver/services/current_trip.dart';
import 'package:driver/services/database.dart';
import 'package:driver/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';


class ScanQRCode extends StatefulWidget {
  String? selectedTripId;
  ScanQRCode(
    this.selectedTripId,
    {Key? key}
  ) : super(key: key);

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState(selectedTripId);
}

class _ScanQRCodeState extends State<ScanQRCode> {
  String? selectedTripId;
  _ScanQRCodeState(this.selectedTripId);

  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;

  @override
  Widget build(BuildContext context) {

    List<Ticket> tickets = Provider.of<List<Ticket>?>(context) ?? [];

    List<CurrentTrip> currentTrips = Provider.of<List<CurrentTrip>?>(context) ?? [];

    CurrentTrip currentTrip = currentTrips.firstWhere((curr) => curr.tripId == selectedTripId);

    Widget result =  tickets.isEmpty ? Loading() : Scaffold(
      appBar: AppBar(
        title: const Text("xBus"),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          if (!_screenOpened) {
            final String code = barcodes[0].rawValue ?? "---";
            Ticket? scannedTicket;
            scannedTicket = tickets.firstWhere((t) => t.id == code);
            if(scannedTicket.checked == false) {
              await updateDB(code, currentTrip).then((value) => {
                _screenOpened = true,
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                    ScanSucceeded(screenClosed: _screenWasClosed, value: code))
                ).then(_goBack),
              });
            } else {
              _screenOpened = true;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                  ScanFailed(screenClosed: _screenWasClosed))
              ).then(_goBack);
            }
          }
        },
      ),
    );
    return result;
  }

  void _screenWasClosed() {
    _screenOpened = false;
  }

  void _goBack(value) { 
    if(value!=null && value==true) {
      Navigator.pop(context);
    }
  }
  updateDB(String code, CurrentTrip currentTrip) {
    return DatabaseService().updateTicket(code, {
      'Checked': true,
    }).then((value) {
      CurrentTripService().updateCurrentTrip(
        currentTrip.id,
        {
          'PassengersQtyAfter': currentTrip.passengersQtyAfter + 1,
          'PassengersQtyBefore': currentTrip.passengersQtyAfter,
          'PassengersQtyNew': 1,
        }
      );
    });
  }
}
