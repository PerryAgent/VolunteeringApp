import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import './home_page.dart';
import './google_signin_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff99D98C),
      body : Center(
        child : Container(
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Container(
                child: Text(
                  'Helpp!',
                  style: GoogleFonts.comfortaa(textStyle: TextStyle(
                    color: Color(0xff184E77),
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  )
                ),
              ),
            ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 300, 0, 0),
                child : ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    minimumSize: Size(250, 50),
                  ),
                  icon : FaIcon(FontAwesomeIcons.google, color: Colors.red,),
                  label: Text(" Sign in with Google",),
                  onPressed: () async {
                    GoogleSignInHelper googleSignInHelper = GoogleSignInHelper();
                    await googleSignInHelper.googleLogin();
                  },
                )
              ),
            ],
          )
        )
      ),
    );
  }
}

class Interim extends StatefulWidget {
  
  Interim({super.key});

  @override
  State<Interim> createState() => _InterimState();
}

class _InterimState extends State<Interim> {

  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder:  (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        else if(snapshot.hasError){
          return Center(child : Text("Login Unsucessful"));
        }
        else if(snapshot.hasData){
          return MyHomePage();
        }
        else{
          return LoginPage();
        }
      },
    ),
  );
}

