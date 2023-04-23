import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

class Page2 extends StatelessWidget {
  String? code;
  // QRViewController? controller;
  Page2(
    this.code,
    // this.controller,
  );

  @override
  Widget build(BuildContext context) {
    // if (controller?.pauseCamera() != null) {
    //   controller?.pauseCamera();
    // }
    // else {
    //   print('pauseCamera é null');
    // }
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