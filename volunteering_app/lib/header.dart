import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:volunteering_app/profile.dart';

class Header extends StatelessWidget implements PreferredSizeWidget{
  final AppBar appBar;

  const Header({required this.appBar});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Hellp!",
        style: GoogleFonts.comfortaa()
      ),
      backgroundColor: Color(0xFF52b69a),
      leading: GestureDetector(
        onTap: () {
          print("Clicked");
          Scaffold.of(context).openDrawer();
        },
        child: Icon(
          Icons.menu,  // add custom icons also
        ),
      ),
      actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
              },
              child: Icon(
                Icons.card_giftcard,
                size: 26.0,
              ),
            )
        ),
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return Profile();
                }));
              },
              child: Icon(
                  Icons.person,
                  size: 30,
              ),
            )
        ),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}