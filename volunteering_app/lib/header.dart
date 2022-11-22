import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:icon_forest/icon_forest.dart';

class Header extends StatelessWidget implements PreferredSizeWidget{
  final AppBar appBar;

  const Header({required this.appBar});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("VoluntMe",
        style: GoogleFonts.comfortaa()
      ),
      backgroundColor: Colors.greenAccent,
      leading: GestureDetector(
        onTap: () {
          print("Clicked");
        },
        child: Icon(
          Icons.menu,  // add custom icons also
        ),
      ),
      actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.currency_rupee_outlined,
                size: 26.0,
              ),
            )
        ),
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                  Icons.person_outlined
              ),
            )
        ),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}