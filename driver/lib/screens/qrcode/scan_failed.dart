import 'package:flutter/material.dart';
import 'dart:async';

class ScanFailed extends StatefulWidget {
  final Function() screenClosed;
  const ScanFailed({
    Key? key,
    required this.screenClosed,
  }) : super(key: key);

  @override
  State<ScanFailed> createState() => _ScanFailedState(screenClosed: screenClosed);
}

class _ScanFailedState extends State<ScanFailed> {
  final Function() screenClosed;
  _ScanFailedState({
    required this.screenClosed,
  });

  goBack () {
    widget.screenClosed();
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {

    Timer(const Duration(milliseconds: 3000), goBack);

    return Scaffold(
      appBar: AppBar(
        title: const Text("xBus"),
        centerTitle: true,
        leading: IconButton(
          onPressed: goBack,
          icon: const Icon(Icons.arrow_back_outlined,),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("ATENÇÃO!\nticket já utlizado", style: TextStyle(fontSize: 20,color: Colors.red),),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}