import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;

  SignIn({ required this.toggleView });

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Driver SignIn')
    );
  }
}