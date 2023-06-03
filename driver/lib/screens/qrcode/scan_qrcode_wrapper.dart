import 'package:driver/models/ticket.dart';
import 'package:driver/screens/qrcode/scan.dart';
import 'package:driver/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScanQRCodeWrapper extends StatefulWidget {
  const ScanQRCodeWrapper({super.key});

  @override
  State<ScanQRCodeWrapper> createState() => _ScanQRCodeWrapperState();
}

class _ScanQRCodeWrapperState extends State<ScanQRCodeWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Ticket>?>.value(
          value: DatabaseService().tickets,
          initialData: null,
        ),
      ],
      child: ScanQRCode()
    );
  }
}