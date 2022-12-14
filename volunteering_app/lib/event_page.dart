import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:volunteering_app/applications_list.dart';
import './header.dart';
import './sideBar.dart';

List<List<bool>> isSelected = <List<bool>> [];


class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.eventDetails});

  final Map eventDetails;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {

  

  @override
  final _user = FirebaseAuth.instance.currentUser!;
  Map currentEvent = Map();

  addUserToEvent() async{
      
    final database = FirebaseDatabase.instance.ref().child('Event').child(widget.eventDetails['key'].toString()); //child(x['key'].toString());
    var x = Map<String, dynamic>.from(widget.eventDetails);
    print("The value of x is" + x.toString());

    if(!x.containsKey('applications')){
      x['applications'] = List.empty(growable: true);
    }

    x['applications'] = x['applications'].toList(); 

    if(x['applications'].contains(_user.displayName)){
      return;
    }

    if(x.containsKey('accepted')){
      x['accepted'] = x['accepted'].toList();
      if(x['accepted'].contains(_user.displayName)){
        return;
      }
    }
    
    x['applications'].add(_user.displayName);

    database.update(x);
  }

  FutureOr onBack(dynamic value){
    setState(() {
      print("inside on back");
    });
  }

  Future<DataSnapshot> getEventDetails () async{
    return FirebaseDatabase.instance.ref().child('Event').child(widget.eventDetails['key'].toString()).get();//.then( (snapshot)  {
  }

  Widget build(BuildContext context){



    return  FutureBuilder( 
      future : getEventDetails(),
      builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot){
        currentEvent = Map<String, dynamic>.from(snapshot.data!.value as Map);
        print("This is the current event : " + currentEvent.toString());
        double screenWidth = MediaQuery.of(context).size.width;
        String buttonText = "";
        bool isOwner = false;
        if(_user.displayName == currentEvent['userName']){
          buttonText = "See Applications";
          isOwner = true;
        }
        else if(currentEvent.containsKey('applications') && currentEvent['applications'].contains(_user.displayName)){
          buttonText = "Application Pending";
        }
        else if(currentEvent.containsKey('accepted') && currentEvent['accepted'].contains(_user.displayName)){
          buttonText = "Application Accepted";
        }
        else{
          buttonText = "Apply Now";
        }

        String acceptedUsers = "";

        if(currentEvent.containsKey('accepted')){
          for (String name in currentEvent['accepted']){
            acceptedUsers += name;
            acceptedUsers += '\n';
          }
        }

        // setState(() {
        //   print("Inside build\n");        
        // });

        Widget displaySlots(){
          List<Widget> list = <Widget>[];
          for(var i = 1; i <= int.parse(currentEvent['eventDays']); i++){
            if(currentEvent.containsKey('day' + i.toString())){
              List<Object?> temp = currentEvent['day' + i.toString()];

              list.add(
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                      child : Text(
                      "Day " + i.toString(),
                      style: GoogleFonts.comfortaa(textStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 15 )),
                      ),
                    ),

                    Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                      child : GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, 
                        crossAxisSpacing: 16),
                      children: List.generate(currentEvent['day' + i.toString()].length, (index) {
                        return (
                          Text(currentEvent['day' + i.toString()][index].toString())
                        );
                      })
                    ),)

                  ],
                )
              );
            }
          }

          return new Column(children: list);
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
                            currentEvent['eventDate'],
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
                            currentEvent['numberOfPeople'],
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
                            currentEvent['userName'],
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
                          'Slots',
                          style: GoogleFonts.comfortaa(textStyle: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 20 )),
                        ),

                      ),
                      displaySlots(),

                    ]
                  )
                )
              ),

              SizedBox(height: 10,),

              // Accepted volunteers
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
                    }))
                    .then(onBack);
                  }
                  else{
                    addUserToEvent();
                  }
                  setState(() {
                    
                  });
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
    );
      }
}
