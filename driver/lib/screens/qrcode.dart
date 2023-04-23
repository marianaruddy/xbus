import 'package:driver/models/ticket.dart';
import 'package:driver/screens/comfirm_scan.dart';
import 'package:driver/services/database.dart';
import 'package:driver/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class QrCodePage extends StatelessWidget {
  QrCodePage({Key? key});
  
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Ticket>?>.value(
          value: DatabaseService().tickets,
          initialData: null,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mobile Scanner'),
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state as TorchState) {
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
                  switch (state as CameraFacing) {
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
        body: QRCodePageBody(cameraController),
      )
    );
  }
}

class QRCodePageBody extends StatefulWidget {
  MobileScannerController cameraController;
  QRCodePageBody(this.cameraController);

  @override
  State<QRCodePageBody> createState() => _QRCodePageBodyState(cameraController);
}

class _QRCodePageBodyState extends State<QRCodePageBody> {
  
  MobileScannerController cameraController;
  _QRCodePageBodyState(this.cameraController);

  @override
  Widget build(BuildContext context) {
  
    List<Ticket> tickets = Provider.of<List<Ticket>?>(context) ?? [];

    print('tickets $tickets');
    if (tickets.length < 1) {
      return Loading();
    }
    else {

    return MobileScanner(
      // fit: BoxFit.contain,
      controller: cameraController,
      onDetect: (capture) async {
        final List<Barcode> barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          debugPrint('Barcode found! ${barcode.rawValue}');
        }
        cameraController.stop();
        String? code = barcodes[0].rawValue;
        bool isTicketChecked = false;
        Ticket? scannedTicket;
        for (Ticket t in tickets) {
          if (t.id == code) {
            scannedTicket = t;
            if(scannedTicket.checked == false) {
              await DatabaseService().updateTicket(code, {
                'Checked': true,
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ConfirmScan(barcodes[0].rawValue);
                }),
              ).then((value) => cameraController.start());
            }
            else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ConfirmScan('ERROR: Ticket já usado');
                }),
              ).then((value) => cameraController.start());
            }
          }
        }
      });
    }
  }
}