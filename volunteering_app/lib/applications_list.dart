import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import './sideBar.dart';
import './header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ApplicationsList extends StatefulWidget {
  const ApplicationsList({super.key, required String this.dbkey});

  final String dbkey;

  @override
  State<ApplicationsList> createState() => _ApplicationsListState();
}

class _ApplicationsListState extends State<ApplicationsList> {
  @override


  Widget build(BuildContext context) {
    
    final database = FirebaseDatabase.instance.ref().child('Event/' + widget.dbkey + '/applications');
    final database1 = FirebaseDatabase.instance.ref().child('Event/' + widget.dbkey + '/accpeted');

    return Scaffold(
      backgroundColor: Color(0xffB5E48C),
      drawer: SideBar(),
      appBar: Header(
        appBar: AppBar(),
      ),
    
      body : Center(
        child : Column(
          children :  <Widget> 
          [
            Container(
              color: Color(0xffB5E48C),

              child: FirebaseAnimatedList(
                query: database,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 15),
                itemBuilder : (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
                  // Map event = snapshot.value as Map;
                  print(snapshot.value);
                  return ApplicantBox(name : snapshot.value.toString(), dbKey: widget.dbkey, );
                } ,
              ),
            ),
          ]
        ) 
         
        ),
    );
  }
}

class ApplicantBox extends StatefulWidget {
  const ApplicantBox({super.key, required this.name, required this.dbKey});

  final String dbKey;
  final String name;

  @override
  State<ApplicantBox> createState() => _ApplicantBoxState();
}

class _ApplicantBoxState extends State<ApplicantBox> {
  
  acceptUser() async{
    // final database = FirebaseDatabase.instance.ref().child('Event').child(widget.name.toString()); 
    Map event = {};
    
    // get event details
    final database = await FirebaseDatabase.instance.ref().child("Event").child(widget.dbKey.toString()).get().then( (snapshot)  {
        
      if(snapshot.exists){
        print(snapshot.value);
        event = snapshot.value as Map;
      }
      else{
        print("Not Exists");
      }
    });

    print("Got Event");

    var x = Map<String, dynamic>.from(event);

    if(!x.containsKey('applications')){
      throw Exception("Applications cannot be empty");
    }

    x['applications'] = x['applications'].toList(); 
    print(x['applications']);
    
    List<String> temp = [];
    for(String name in x['applications']){
      temp.add(name);
    }

    print(temp);

    if(!x['applications'].contains(widget.name)){
      throw Exception("User does not exist in applications");
    }

    if(!x.containsKey('accepted')){
      x['accepted'] = List.empty(growable: true);
    }

    x['accepted'] = x['accepted'].toList();

    x['accepted'].add(widget.name);
    x['applications'].remove(widget.name);

    final database1 = FirebaseDatabase.instance.ref().child('Event').child(widget.dbKey.toString()); //child(x['key'].toString());

    await database1.update(x);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      color: Color(0xffB5E48C),

      child : Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        color: Color(0xff34A0A4),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget> [
            Text(widget.name,
              style: GoogleFonts.comfortaa(
                textStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
             children: <Widget> [
              Container(
                child : Align(
                  alignment : Alignment.centerLeft, 
                  child : IconButton(
                    onPressed:() {
                      acceptUser();
                      print("pressed tick");
                    }, 
                    icon: Icon(
                      Icons.check,
                      color: Color(0xff184E77),
                    ),
                  )
                )
              ),
              Container(
                child : Align(
                  alignment : Alignment.centerLeft, 
                  child : IconButton(
                    onPressed:() {
                    }, 
                    icon: Icon(
                      Icons.close,
                      color: Color(0xff184E77),
                    ),
                  )
                )
              )
             ], 
            ),
          ],
        ),
      )
    );
  }
}