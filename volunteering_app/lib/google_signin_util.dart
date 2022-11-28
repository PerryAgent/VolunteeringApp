import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './login_page.dart';

class GoogleSignInHelper {

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async{

    final googleUser = await _googleSignIn.signIn();
    if(googleUser == null){
      return;
    }
    _user = googleUser;
    print("HEREE");
    final googleAuth = await googleUser.authentication;

    final cred = GoogleAuthProvider.credential( 
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(cred);
    Interim();
  }

  logOut()  async {
    
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    _googleSignIn.disconnect();
    Interim();

  }
}