import 'package:driver/models/current_trip.dart';
import 'package:driver/models/ticket.dart';
import 'package:driver/screens/qrcode/scan.dart';
import 'package:driver/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScanQRCodeWrapper extends StatefulWidget {
  String? selectedTripId;
  ScanQRCodeWrapper(
    this.selectedTripId,
    {super.key}
  );

  @override
  State<ScanQRCodeWrapper> createState() => _ScanQRCodeWrapperState(selectedTripId);
}

class _ScanQRCodeWrapperState extends State<ScanQRCodeWrapper> {
  String? selectedTripId;
  _ScanQRCodeWrapperState(
    this.selectedTripId,
  );
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Ticket>?>.value(
          value: DatabaseService().tickets,
          initialData: null,
        ),
        StreamProvider<List<CurrentTrip>?>.value(
          value: DatabaseService().currentTrips,
          initialData: null,
        ),
      ],
      child: ScanQRCode(selectedTripId)
    );
  }
}