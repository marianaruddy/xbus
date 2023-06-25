import 'package:driver/models/current_trip.dart';
import 'package:driver/models/ticket.dart';
import 'package:driver/services/current_trip.dart';
import 'package:driver/services/ticket.dart';
import 'package:driver/services/trip.dart';
import 'package:driver/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRCode extends StatefulWidget {
  String? selectedTripId;
  String? routeId;
  ScanQRCode(this.selectedTripId, this.routeId, {Key? key}) : super(key: key);

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState(selectedTripId, routeId);
}

class _ScanQRCodeState extends State<ScanQRCode> {
  String? selectedTripId;
  String? routeId;
  _ScanQRCodeState(this.selectedTripId, this.routeId);

  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;
  CurrentTrip? currentTrip;

  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> getData() async {
      List<CurrentTrip?>? currentTrips = await CurrentTripService().getOrderedCurrTripsFromTrip(selectedTripId, routeId);
      List<Ticket?> tickets = await TicketService().getTicketsInstances();

      Map<String, dynamic> data = {
        "currentTrips": currentTrips,
        "tickets": tickets,
      };

      return data;
    }

    Future openConfirmModal(context, bool? isSuccess) {
      _screenOpened = true;
      String? modalText;
      if (isSuccess == null) {
        modalText = 'Ops... Ticket inválido. Tente um ticket válido!';

      } else if (isSuccess) {
        modalText = 'Ticket escaneado com sucesso!';
      }
      else {
        modalText = 'Ops... Ticket já utilizado. Tente um ticket válido';
      }
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(modalText ?? ''),
          actions: [
            TextButton(
              onPressed: () => {
                setState(() {
                  _screenOpened = false;
                }),
                Navigator.of(context).pop()
              },
              child: const Text('Fechar')
            ),
          ],
        ),
      );
    }

    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<CurrentTrip?>? currentTrips = snapshot.data?['currentTrips'];
          List<Ticket?>? tickets = snapshot.data?['tickets'];
          currentTrip = currentTrips?.firstWhere((curr) => (
            curr?.tripId == selectedTripId
          ));

          return Scaffold(
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
                  scannedTicket = tickets?.firstWhere((t) => t?.id == code, orElse: () => null);
                  if (scannedTicket == null) {
                    openConfirmModal(context, null).then(_goBack);
                  } else if (scannedTicket.used == false && scannedTicket.active == true && scannedTicket.checked == true) {
                    await updateDB(code, currentTrip).then((value) => {
                      openConfirmModal(context, true).then(_goBack),
                    });
                  } else {
                    openConfirmModal(context, false).then(_goBack);
                  }
                }
              },
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        } else {
          return const Text('[ERRO]');
        }
      },
    );
  }

  void _goBack(value) {
    Navigator.pop(context);
  }

  updateDB(String code, CurrentTrip? currentTrip) {
    return TicketService().updateTicket(code, {
      'Used': true,
    }).then((value) {
      if (currentTrip != null) {
        CurrentTripService().updateCurrentTrip(currentTrip.id, {
          'PassengersQtyAfter': currentTrip.passengersQtyAfter + 1,
          'PassengersQtyBefore': currentTrip.passengersQtyAfter,
          'PassengersQtyNew': 1,
        });
      }
    }).then((value) {
      if (currentTrip != null) {
        TripService().updateTrip(currentTrip.tripId, {
          'PassengersQty': currentTrip.passengersQtyAfter + 1,
        });
      }
    });
  }
}
