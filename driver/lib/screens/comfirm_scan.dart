import 'package:flutter/material.dart';
import 'dart:async';

class ConfirmScan extends StatelessWidget {
  String? code;
  ConfirmScan(
    this.code,
  );

  @override
  Widget build(BuildContext context) {

    Timer(const Duration(milliseconds: 3000), () => Navigator.pop(context));

    return  Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: Text('ticket scaneado com sucesso: \n$code'),
    );
  }
}