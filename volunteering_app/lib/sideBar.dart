import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './main.dart';
import './profile.dart';
import './home_page.dart';

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
                  child: Text("Helpp!",
                  style: GoogleFonts.comfortaa(
                    textStyle: TextStyle(color: Colors.white, fontSize: 30)),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF52B69A),
                ),
            ),
            Options(name: "Home", id: 0),
            Options(name: "My Events", id: 1),
            Options(name: "My Applications", id: 2),
            Divider(
              color: Colors.black54,
            ),
            Options(name: "Chats", id: 3),
            Options(name: "My Profile", id: 4),
            Divider(
              color: Colors.black54,
            ),
            Options(name: "Store", id: 5),
            Options(name: "Contact Us", id: 6),

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
  final int id;
  const Options({required String this.name, required int this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: GestureDetector(
        onTap: (){
          print("Clicked on " + name);
          Navigator.pop(context);
          switch (id) {
            case 0: Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return MyHomePage();
                    }));
                    break;
            case 4: Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return Profile();
                    }));
                    break;
          }
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