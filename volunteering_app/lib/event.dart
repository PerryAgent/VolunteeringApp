import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import './event_page.dart';

class EventBox extends StatefulWidget {
  const EventBox({super.key, required this.eventName, required this.eventPic, required this.eventDate});

  final String eventName; 
  final String eventPic; 
  final String eventDate;

  @override
  State<EventBox> createState() => _EventBoxState();
}

class _EventBoxState extends State<EventBox> {

  void func(BuildContext context) async {
    // print(widget.eventName);
      
      // HIII
      Map event = Map();
      String name = "";
      final database = await FirebaseDatabase.instance.ref().child("Event").orderByChild("eventName").equalTo(widget.eventName).get().then( (snapshot)  {
        
        if(snapshot.exists){
          event = snapshot.value as Map;
          var key = event.keys.first;
          event = event.values.first;
          print(key);
          event['key'] = key;
        }
        else{
          print("Not Exists");
        }
      });
      print(event.runtimeType);
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
        return EventPage(eventDetails: event);
      }));
  }
 
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      // Where you style the container
      height: 150,
      width: screenWidth * 0.9,
      child: GestureDetector(
    
        onTap: () { 
          func(context);
        },
        child : Card(
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
              gradient: new LinearGradient(
                  stops: [0.02, 0.02],
                  colors: [Color(0xff99D98C), Colors.white]
              ),
              borderRadius: new BorderRadius.all(const Radius.circular(6.0))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 80,
                    width: 150,
                    padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                    child: Container(
                      height: 80,
                      width: 80,
                      child : Image(image: AssetImage(widget.eventPic))
                    ),
                  ),
                  SizedBox(width: 20),
                  Flexible(
                  // padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                   child : Text(
                      widget.eventName,
                      style: GoogleFonts.comfortaa(
                        textStyle: TextStyle(
                          fontSize: 24
                        ),
                      ),
                    ),
                  ),
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
                        widget.eventDate,
                        style: GoogleFonts.comfortaa(
                          textStyle: TextStyle(
                          fontSize: 20
                          ),
                        ),
                      ),
                    )
                  )
                ],
              )
            ],
          ),
        ),
      ),)
    );
  }
}
