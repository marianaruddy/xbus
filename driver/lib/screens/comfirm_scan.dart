import 'package:driver/models/ticket.dart';
import 'package:driver/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ConfirmScan extends StatelessWidget {
  String? code;
  ConfirmScan(
    this.code,
  );

  @override
  Widget build(BuildContext context) {

    // final tickets = Provider.of<List<Ticket>?>(context) ?? [];

    // print('tickets $tickets');

    return MultiProvider(
      providers: [
        StreamProvider<List<Ticket>?>.value(
          value: DatabaseService().tickets,
          initialData: null,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: ConfirmScanWidget(code),
      )
    );
  }
}
class ConfirmScanWidget extends StatelessWidget {
  String? code;
  ConfirmScanWidget(
    this.code,
  );

  @override
  Widget build(BuildContext context) {

    final tickets = Provider.of<List<Ticket>?>(context) ?? [];

    print('tickets $tickets');

    for (Ticket t in tickets) {
      if (t.id == code) {
        print("-- id: ${t.id}");
        print("-- BoardingHour: ${t.boardingHour}");
        print("-- Checked: ${t.checked}");
        print("-- Price: ${t.price}");
        print("-- StopId: ${t.stopId}");
        print("-- StopRef: ${t.stopRef}");
      }
      print(t.id);
    }

    return Text('ticket scaneado com sucesso: \n$code');
  }
}