import 'package:driver/models/stop.dart';
import 'package:driver/services/stops.dart';
import 'package:flutter/material.dart';

class StopListItem extends StatefulWidget {
  String stopId;
  String intendedTime;
  StopListItem(this.stopId, this.intendedTime, {super.key});

  @override
  State<StopListItem> createState() => _StopListItemState(stopId, intendedTime);
}

class _StopListItemState extends State<StopListItem> {
  String stopId;
  String intendedTime;
  _StopListItemState(this.stopId, this.intendedTime);
  @override
  Widget build(BuildContext context) {
    String errorText = '[NOME DA PARADA INDISPONÍVEL]';
    String loadingText = '...';

    return FutureBuilder(
      future: StopService().getStopInstanceById(stopId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Stop? stop = snapshot.data;
          return Text('[$intendedTime] ${stop?.name ?? errorText}');
        }
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(loadingText);
        }
        else {
          return Text(errorText);
        }
      },
    );
  }
}