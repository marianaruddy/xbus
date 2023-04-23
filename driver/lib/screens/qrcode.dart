import 'package:driver/screens/comfirm_scan.dart';
import 'package:driver/services/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodePage extends StatelessWidget {
  QrCodePage({Key? key});
  
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return MobileScanner(
          // fit: BoxFit.contain,
          controller: cameraController,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            final Uint8List? image = capture.image;
            for (final barcode in barcodes) {
              debugPrint('Barcode found! ${barcode.rawValue}');
            }
            cameraController.stop();
            try {
              DatabaseService().updateTicket(barcodes[0].rawValue, {
                'Checked': true,
              });
            } catch (e) {
              
            }
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return ConfirmScan(barcodes[0].rawValue);
              }),
            ).then((value) => cameraController.start());
          },
        );
  }
}