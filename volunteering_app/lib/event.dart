import 'package:flutter/material.dart';

class EventBox extends StatefulWidget {
  const EventBox({super.key});

  @override
  State<EventBox> createState() => _EventBoxState();
}

class _EventBoxState extends State<EventBox> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      // Where you style the container
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(50)
      // ),
      height: 150,
      width: screenWidth * 0.9,
      child: Card(
        elevation: 10,
        shape : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 80,
                  width: 80,
                ), 
                Text(
                  "Event Name Here",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Color(0x5fB5E48C),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  height: 30,
                  width: screenWidth * 0.35,
                  child: Center(
                    child : Text(
                      '00:00:10',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
