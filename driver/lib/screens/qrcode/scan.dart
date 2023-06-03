import 'package:driver/models/ticket.dart';
import 'package:driver/screens/qrcode/found_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';


class ScanQRCode extends StatefulWidget {
  const ScanQRCode({Key? key}) : super(key: key);

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;

  @override
  Widget build(BuildContext context) {

    List<Ticket> tickets = Provider.of<List<Ticket>?>(context) ?? [];
    print('tickets: -------------');
    if (tickets.isNotEmpty) {
      tickets.forEach((tkt) {
        print('tickets: ${tkt.id}');
      });
    }

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
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (!_screenOpened) {
            final String code = barcodes[0].rawValue ?? "---";
            debugPrint('Barcode found! $code');
            _screenOpened = true;
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
              FoundCodeScreen(screenClosed: _screenWasClosed, value: code),));
          }
        },
      ),
    );
  }

  void _screenWasClosed() {
    _screenOpened = false;
  }
}
