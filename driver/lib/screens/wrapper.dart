import 'package:driver/screens/authenticate/authenticate.dart';
import 'package:driver/screens/home/home.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    // TODO: firebase auth
    final user = null;

    if (user == null) {
      return Authenticate();
    } else { 
      return Home();
    }

  }
}