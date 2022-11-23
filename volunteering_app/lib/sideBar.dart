import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SideBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                child: Center(
                  child: Text("VoluntMe",
                  style: GoogleFonts.comfortaa(
                    textStyle: TextStyle(color: Colors.white, fontSize: 30)),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                ),
            ),
            Options(name: "Home"),
            Options(name: "My Events"),
            Options(name: "My Applications"),
            Divider(
              color: Colors.black54,
            ),
            Options(name: "Chats"),
            Options(name: "My Profile"),
            Divider(
              color: Colors.black54,
            ),
            Options(name: "Store"),
            Options(name: "Contact Us"),

            /* Footer for the side menu
            Container(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  children: <Widget>[
                    Divider(),
                    ListTile(
                      title: Text('Footer')),
                  ],
                ),
              ),
            ),
            */

          ],
        ),
      ),
    );
  }
}

class Options extends StatelessWidget {
  final String name;
  const Options({required String this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: GestureDetector(
        onTap: (){
          print("Clicked on " + name);
        },
        child: Center(
          child: Text(name,
            style: GoogleFonts.comfortaa(
                textStyle: TextStyle(color: Colors.black54, fontSize: 15)),
          ),
        ),
      ),
    );
  }
}