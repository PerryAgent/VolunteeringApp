import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import './header.dart';
import './event.dart';
import './sideBar.dart';
import './add_event.dart';

var listofEvents = [ ['Event1', 'images/Event1.png', '0:10:00'], ['Event2', 'images/Event1.png', '0:11:00'], ['Event3', 'images/Event1.png', '0:12:00'] ];
int counter = 3;

class MyHomePage extends StatefulWidget {
  
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final database = FirebaseDatabase.instance.ref().child('Event/');
  // database.on("value", function(snapshot) {
  //   console.log(snapshot.val());
  // }, function (error) {
  //   console.log("Error: " + error.code);
  // });

  void _addEvent(){
    counter++;
    listofEvents.add( ['Event' + counter.toString(), 'images/Event1.png', '0:10:00'] );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: SideBar(),
      appBar: Header(
        appBar: AppBar(),
      ),
    
      body : Center(
        child : Container(
            child: FirebaseAnimatedList(
              query: database,
              padding: const EdgeInsets.only(bottom: 15),
              itemBuilder : (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
                Map event = snapshot.value as Map;
                event['key'] = snapshot.key;

                return EventBox(eventName: event["eventName"], eventPic: 'images/Event1.png', eventDate: event["eventDate"]);
              } ,
            ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff99D98C),
        onPressed: (){
          // _addEvent();
          // setState((){});
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
            return AddEvent();
          }));
        },
        tooltip: "Add Event",
        child: const Icon(Icons.add),
      ),

    );
  }
}
