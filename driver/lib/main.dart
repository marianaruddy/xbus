import 'package:driver/models/user.dart';
import 'package:driver/screens/wrapper.dart';
import 'package:driver/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

bool shouldUseFirebaseEmulator = false;

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<XBusUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Wrapper(),
      ),
    );
  }
}

