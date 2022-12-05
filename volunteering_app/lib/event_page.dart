import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:volunteering_app/applications_list.dart';
import './header.dart';
import './sideBar.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.eventDetails});

  final Map eventDetails;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  

  @override
  final _user = FirebaseAuth.instance.currentUser!;


  addUserToEvent() async{
      
    final database = FirebaseDatabase.instance.ref().child('Event').child(widget.eventDetails['key'].toString()); //child(x['key'].toString());
    var x = Map<String, dynamic>.from(widget.eventDetails);

    if(!x.containsKey('applications')){
      x['applications'] = List.empty(growable: true);
    }

    if(x.containsValue(_user.displayName)){
      return;
    }
    
    x['applications'] = x['applications'].toList(); 
    x['applications'].add(_user.displayName);

    database.update(x);
  }

  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    String buttonText = "";
    bool isOwner = false;
    if(_user.displayName == widget.eventDetails['userName']){
      buttonText = "See Applications";
      isOwner = true;
    }
    else if(widget.eventDetails.containsKey('applications') && widget.eventDetails['applications'].contains(_user.displayName)){
      buttonText = "Application Pending";
    }
    else{
      buttonText = "Apply Now";
    }
    String acceptedUsers = "";

    if(widget.eventDetails.containsKey('accepted')){
      for (String name in widget.eventDetails['accepted']){
        acceptedUsers += name;
        acceptedUsers += '\n';
      }
    }

    return Scaffold(
      backgroundColor: Color(0xffD9ED92),
      drawer: SideBar(),
      appBar: Header(
        appBar: AppBar(),
      ),
      body: SingleChildScrollView(
        child : Container(
        child : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget> [
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget> [
            Container(
              height: 150,
              child: Container(
                padding: EdgeInsets.all(10),
                child : Image(
                  image: AssetImage('images/Event1.png'),
                ), 
              ),
            ),
            SizedBox(width: 30),
            Flexible(
              // height: 150,
              // alignment: Alignment.center,
              child : Container(
                // child : Card(
                  child : Text (
                widget.eventDetails['eventName'],
                style: GoogleFonts.comfortaa(textStyle: TextStyle(
                  color: Color(0xFF184E77),
                  fontSize: 25,
                  fontWeight: FontWeight.w800))
                ))
              )
          ]),
          SizedBox(height: 10,),
          Container(
            // height: 1000,
            width: screenWidth - 10,
            color: Color(0xffD9ED92),
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child : Card(
              elevation: 10,
              child : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                    child : Text(
                      'Event Description',
                      style: GoogleFonts.comfortaa(textStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 20 )),
                    ),
                  ),
                  
                  SizedBox(height: 5,),

                  Container(
                    // padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),

                    child : Container(
                      // padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child : Text(
                        widget.eventDetails['eventDetails'],
                        style: GoogleFonts.comfortaa(textStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 13 )),
                      )
                    )
                  ),

                  SizedBox(height: 10,),
                ]
              ),
            ),
          ),

          SizedBox(height: 10,),

          // EVENT DATE
          Container(
            // height: 1000,
            width: screenWidth - 10,
            color: Color(0xffD9ED92),
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child : Card(
              elevation: 10,
              child : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                    child : Text(
                      'Event Date',
                      style: GoogleFonts.comfortaa(textStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 20 )),
                    ),
                  ),
                  
                  SizedBox(height: 5,),

                  Container(
                    // padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),

                    child : Container(
                      // padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child : Text(
                        widget.eventDetails['eventDate'],
                        style: GoogleFonts.comfortaa(textStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 13 )),
                      )
                    )
                  ),

                  SizedBox(height: 10,),
                ]
              ),
            ),
          ),

          

          SizedBox(height: 10,),

          // Number of volunteers required
          Container(
            // height: 1000,
            width: screenWidth - 10,
            color: Color(0xffD9ED92),
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child : Card(
              elevation: 10,
              child : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                    child : Text(
                      'Number Required',
                      style: GoogleFonts.comfortaa(textStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 20 )),
                    ),
                  ),
                  
                  SizedBox(height: 5,),

                  Container(
                    // padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),

                    child : Container(
                      // padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child : Text(
                        widget.eventDetails['numberOfPeople'],
                        style: GoogleFonts.comfortaa(textStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 13 )),
                      )
                    )
                  ),

                  SizedBox(height: 10,),
                ]
              ),
            ),
          ),

          SizedBox(height: 10,),

          // POSTED BY
          Container(
            // height: 1000,
            width: screenWidth - 10,
            color: Color(0xffD9ED92),
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child : Card(
              elevation: 10,
              child : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                    child : Text(
                      'Posted By',
                      style: GoogleFonts.comfortaa(textStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 20 )),
                    ),
                  ),
                  
                  SizedBox(height: 5,),

                  Container(
                    // padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),

                    child : Container(
                      // padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child : Text(
                        widget.eventDetails['userName'],
                        style: GoogleFonts.comfortaa(textStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 13 )),
                      )
                    )
                  ),

                  SizedBox(height: 10,),
                ]
              ),
            ),
          ),

          SizedBox(height: 10,),

          // POSTED BY
          Container(
            // height: 1000,
            width: screenWidth - 10,
            color: Color(0xffD9ED92),
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child : Card(
              elevation: 10,
              child : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                    child : Text(
                      'Volunteers accepted',
                      style: GoogleFonts.comfortaa(textStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 20 )),
                    ),
                  ),
                  
                  SizedBox(height: 5,),

                  Container(
                    // padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),

                    child : Container(
                      // padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child : Text(
                        acceptedUsers,
                        style: GoogleFonts.comfortaa(textStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 13 )),
                      )
                    )
                  ),

                  SizedBox(height: 10,),
                ]
              ),
            ),
          ),

          SizedBox(height: 50,),
          // BOTTOM BUTTON

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor:  Color(0xFF184E77),
            ),
            onPressed: (){
              if(isOwner){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return ApplicationsList(dbkey: widget.eventDetails['key'],);
                }));
              }
              else{
                addUserToEvent();
              }
            }, 
            child: 
              Container(
                // color: Color(0xFF184E77),
                width: screenWidth * 0.5,
                height: 50,
                child : Center(
                  child : Text("$buttonText",
                  style: GoogleFonts.comfortaa(textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15 )))
                ),
              )
            ),

            SizedBox(height: 20,),
          
        ]
      )))
    );
  }
}
