import 'package:flutter/material.dart';

class FoundCodeScreen extends StatefulWidget {
  final String value;
  final Function() screenClosed;
  const FoundCodeScreen({
    Key? key,
    required this.value,
    required this.screenClosed,
  }) : super(key: key);

  @override
  State<FoundCodeScreen> createState() => _FoundCodeScreenState(screenClosed: screenClosed, value: value);
}

class _FoundCodeScreenState extends State<FoundCodeScreen> {
  final String value;
  final Function() screenClosed;
  _FoundCodeScreenState({
    required this.value,
    required this.screenClosed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("xBus"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            widget.screenClosed();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_outlined,),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Scanned Code:", style: TextStyle(fontSize: 20,),),
              const SizedBox(height: 20,),
              Text(widget.value, style: const TextStyle(fontSize: 16,),),
            ],
          ),
        ),
      ),
    );
  }
}