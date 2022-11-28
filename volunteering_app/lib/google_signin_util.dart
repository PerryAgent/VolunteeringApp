import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInHelper extends ChangeNotifier {

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
    notifyListeners();
  }

  logOut()  async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    _googleSignIn.disconnect();
  }
}