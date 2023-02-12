import 'package:driver/models/user.dart';
import 'package:driver/screens/authenticate/authenticate.dart';
import 'package:driver/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<XBusUser?>(context);

    if (user == null) {
      return Authenticate();
    } else { 
      return Home();
    }

  }
}