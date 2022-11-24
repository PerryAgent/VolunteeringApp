import 'package:flutter/material.dart';
import './home_page.dart';

class Splash extends StatefulWidget {

  const Splash();

  @override
  _SplashState createState() => _SplashState();

}

class _SplashState extends State<Splash> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goToHome();
  }

  void goToHome() async{
    await Future.delayed(Duration(milliseconds: 1500), (){});
    Navigator.of(context).pushReplacement(
       MaterialPageRoute(builder: (BuildContext context) {
        return MyHomePage();
      })
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Center(
        child : Container(
          // ignore: prefer_const_constructors
          child : (Text(
              'Splash Screen',
              // ignore: prefer_const_constructors
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Roboto',
              ),
            )
          ),
        )
      ,) 
    );
  }
}
