import 'package:flutter/material.dart';

class ConfirmScan extends StatelessWidget {
  String? code;
  ConfirmScan(
    this.code,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(code ?? 'sem codigo'),
        ),
      ),
    );
  }
}