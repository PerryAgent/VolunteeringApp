import 'package:flutter/material.dart';
import './sideBar.dart';
import './header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {

  final _user = FirebaseAuth.instance.currentUser!;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: Header(
        appBar: AppBar(),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(widget._user.photoURL!),
                  fit: BoxFit.fill
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Center(
                    child: Text(widget._user.displayName!,
                      style: GoogleFonts.comfortaa(textStyle: TextStyle(fontSize: 15)),)
                ),
                Center(
                    child: Text(widget._user.email!,
                      style: GoogleFonts.comfortaa(textStyle: TextStyle(fontSize: 15)),)
                ),
              ]
            ),
            Divider(color: Colors.black54,),
            Container(
              height: 420,
              child: Text("Details of user to be filled later",
              style: GoogleFonts.comfortaa(),),
            )
          ],
        ),
      ),
    );
  }
}