import 'package:flutter/material.dart';
import 'dart:async';

class ScanSucceeded extends StatefulWidget {
  final String value;
  final Function() screenClosed;
  const ScanSucceeded({
    Key? key,
    required this.value,
    required this.screenClosed,
  }) : super(key: key);

  @override
  State<ScanSucceeded> createState() => _ScanSucceededState(screenClosed: screenClosed, value: value);
}

class _ScanSucceededState extends State<ScanSucceeded> {
  final String value;
  final Function() screenClosed;
  _ScanSucceededState({
    required this.value,
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
            children: [
              const Text("ticket scaneado com sucesso:", style: TextStyle(fontSize: 20,),),
              const SizedBox(height: 20,),
              Text(widget.value, style: const TextStyle(fontSize: 16,),),
            ],
          ),
        ),
      ),
    );
  }
}