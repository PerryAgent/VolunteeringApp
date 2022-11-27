import 'package:flutter/material.dart';
import 'package:volunteering_app/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoluntMe',
      home: Splash(),
    );
  }
}
