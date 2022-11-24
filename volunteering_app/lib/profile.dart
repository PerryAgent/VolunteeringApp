import 'package:flutter/material.dart';
import './sideBar.dart';
import './header.dart';
import 'package:google_fonts/google_fonts.dart';


class Profile extends StatefulWidget {
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
              child: Image.asset('images/defaultPic.png')
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Center(
                    child: Text("Name Here",
                      style: GoogleFonts.comfortaa(textStyle: TextStyle(fontSize: 15)),)
                ),
                Center(
                    child: Text("Email Here",
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