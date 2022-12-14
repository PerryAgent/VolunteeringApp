import 'package:flutter/material.dart';
import 'package:volunteering_app/home_page.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import './login_page.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return AnimatedSplashScreen(
        backgroundColor: Color(0xFF52b69a),
        duration: 2000,
        splash: Center(
         child: Container(
          height: 50,
          color: Colors.white,
          child: Center(
            child: Text("Helpp!",
              style: GoogleFonts.comfortaa(textStyle: TextStyle(
                  color: Color(0xFF52b69a),
                  fontSize: 40)),),
          ),
         ),
        ),
        nextScreen: Interim(),
        splashTransition: SplashTransition.slideTransition,
        pageTransitionType: PageTransitionType.bottomToTop,
    );
  }
}