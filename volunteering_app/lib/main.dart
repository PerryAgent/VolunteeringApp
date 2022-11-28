import 'package:flutter/material.dart';
import 'package:volunteering_app/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import './google_signin_util.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Helpp!',
      home: Splash(),
    );
  } 
    
}
