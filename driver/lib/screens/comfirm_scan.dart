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

    return  Scaffold(
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: Text('ticket scaneado com sucesso: \n$code'),
      
    );
  }
}