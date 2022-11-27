import 'package:flutter/material.dart';
import './header.dart';
import './event.dart';
import './sideBar.dart';

var listofEvents = [ ['Event1', 'images/Event1.png', '0:10:00'], ['Event2', 'images/Event1.png', '0:11:00'], ['Event3', 'images/Event1.png', '0:12:00'] ];
int counter = 3;

class MyHomePage extends StatefulWidget {
  
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
        child : ListView.builder(
          itemCount: listofEvents.length,
          padding: const EdgeInsets.only(bottom: 15),
          itemBuilder : (BuildContext context, int index){
            return EventBox(eventName: (listofEvents[index][0]), eventPic: listofEvents[index][1], timeLeft: listofEvents[index][2]);
          } ,
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff99D98C),
        onPressed: (){
          _addEvent();
          setState((){});
        },
        tooltip: "Add Event",
        child: const Icon(Icons.add),
      ),

    );
  }
}
