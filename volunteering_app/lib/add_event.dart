import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './header.dart';
import './home_page.dart';
import './sideBar.dart';

Map<String, dynamic> event = new Map();
List<String> slots = [
  "06:00-07:59",
  "08:00-09:59",
  "10:00-11:59",
  "12:00-13:59",
  "14:00-15:59",
  "16:00-17:59",
  "18:00-19:59",
  "20:00-21:59",
  "22:00-23:59"
];
List<List<bool>> isSelected = <List<bool>>[];
String errorText = "";

class AddEvent extends StatefulWidget{

  AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {

  // final database = FirebaseDatabase.instance.ref().child('Event/');
  final _user = FirebaseAuth.instance.currentUser!;
  List<TextEditingController> _controller = List.generate(5, (index) => TextEditingController());
  List<bool> _validate = List.generate(4, (index) => true);

  @override
  void initState() {
    event.clear();
    isSelected.clear();
    errorText = "";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: SideBar(),
      appBar: Header(
        appBar: AppBar(),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height*0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Enter your event details", style: GoogleFonts.comfortaa(
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)
                    ),),
                    TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.event),
                        hintText: "Event Name",
                        errorText: !_validate[0] ? "This is a required field" : null,
                      ),
                      controller: _controller[0],

                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.event_note),
                        hintText: "Event Details",
                        errorText: !_validate[1] ? "This is a required field" : null,
                      ),
                      controller: _controller[1],
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.calendar_today),
                        hintText: "Starting Date of event",
                        errorText: !_validate[2] ? "This is a required field" : null,
                      ),
                      readOnly: true,
                      controller: _controller[2],
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2025),
                        );
                        if(pickedDate != null){
                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                          _controller[2].text = formattedDate;
                          setState(() {});
                        }
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.format_list_numbered),
                        hintText: "Number of Days in event",
                        errorText: !_validate[3] ? "This is a required field" :
                        (_controller[3].text == "0") ? "Number of days cannot be zero" :
                        null,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly], // Only numbers can
                      controller: _controller[3],
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.people),
                        hintText: "Number of people required",
                        errorText: (_controller[4].text == "0") ? "Number of people cannot be zero" :
                        null,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly], // Only numbers can
                      controller: _controller[4],
                    ),
                    ElevatedButton(
                      onPressed: (){
                        int required = 0;
                        for(int ind=0; ind<_validate.length; ind++){
                          _validate[ind] = !(_controller[ind].text.isEmpty);
                          if (_validate[ind])
                            required++;
                        }
                        setState(() {});
                        if (_controller[3].text == "0" || _controller[4].text == "0")
                          return;
                        if (required == _validate.length) {
                          event = {
                            'userName': _user.displayName!,
                            'email': _user.email!,
                            'eventName': _controller[0].text,
                            'eventDetails': _controller[1].text,
                            'eventDate': _controller[2].text,
                            'eventDays':_controller[3].text,
                            'numberOfPeople': _controller[4].text,
                            'dateOfUpload': DateFormat('yyyy-MM-dd').format(DateTime.now())
                          };
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                            return AddSlots();
                          }));
                        }
                      },
                      child: Text(
                        "Add time slots",
                        style: GoogleFonts.comfortaa(),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF52b69a),
                      ),
                    )
                  ],
                ),
            ),
            ],
        ),
      ),
    );
  }
}

class AddSlots extends StatefulWidget{

  @override
  State<AddSlots> createState() => _AddSlotState();
}

class _AddSlotState extends State<AddSlots> {

  final database = FirebaseDatabase.instance.ref().child('Event/');
  final _user = FirebaseAuth.instance.currentUser!;
  List<TextEditingController> _controller = List.generate(5, (index) => TextEditingController());
  List<bool> _validate = List.generate(4, (index) => true);

  @override
  Widget getSlotList() {

    int days = int.parse(event["eventDays"]!);
    List<Widget> list = <Widget>[];

    for (var i = 0; i < days; i++) {
      if (isSelected.length < days) {
        isSelected.add(List.filled(9, false));
      }
      list.add(
          new Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Day " + (i+1).toString(),
                      style: GoogleFonts.comfortaa(
                        fontSize: 20
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: (){
                            if (!isSelected[i][0]) {
                              isSelected[i][0] = true;
                            } else {
                              isSelected[i][0] = false;
                            }
                            setState((){});
                          },
                          child: Text(
                            slots[0],
                            style: GoogleFonts.comfortaa(
                              color: isSelected[i][0]?Colors.white:Color(0xFF52b69a),
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected[i][0]?Color(0xFF52b69a):Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (){
                            if (!isSelected[i][1]) {
                              isSelected[i][1] = true;
                            } else {
                              isSelected[i][1] = false;
                            }
                            setState((){});
                          },
                          child: Text(
                            slots[1],
                            style: GoogleFonts.comfortaa(
                              color: isSelected[i][1]?Colors.white:Color(0xFF52b69a),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected[i][1]?Color(0xFF52b69a):Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (){
                            if (!isSelected[i][2]) {
                              isSelected[i][2] = true;
                            } else {
                              isSelected[i][2] = false;
                            }
                            setState((){});
                          },
                          child: Text(
                            slots[2],
                            style: GoogleFonts.comfortaa(
                              color: isSelected[i][2]?Colors.white:Color(0xFF52b69a),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected[i][2]?Color(0xFF52b69a):Colors.white,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: (){
                            if (!isSelected[i][3]) {
                              isSelected[i][3] = true;
                            } else {
                              isSelected[i][3] = false;
                            }
                            setState((){});
                          },
                          child: Text(
                            slots[3],
                            style: GoogleFonts.comfortaa(
                              color: isSelected[i][3]?Colors.white:Color(0xFF52b69a),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected[i][3]?Color(0xFF52b69a):Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (){
                            if (!isSelected[i][4]) {
                              isSelected[i][4] = true;
                            } else {
                              isSelected[i][4] = false;
                            }
                            setState((){});
                          },
                          child: Text(
                            slots[4],
                            style: GoogleFonts.comfortaa(
                              color: isSelected[i][4]?Colors.white:Color(0xFF52b69a),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected[i][4]?Color(0xFF52b69a):Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (){
                            if (!isSelected[i][5]) {
                              isSelected[i][5] = true;
                            } else {
                              isSelected[i][5] = false;
                            }
                            setState((){});
                          },
                          child: Text(
                            slots[5],
                            style: GoogleFonts.comfortaa(
                              color: isSelected[i][5]?Colors.white:Color(0xFF52b69a),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected[i][5]?Color(0xFF52b69a):Colors.white,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: (){
                            if (!isSelected[i][6]) {
                              isSelected[i][6] = true;
                            } else {
                              isSelected[i][6] = false;
                            }
                            setState((){});
                          },
                          child: Text(
                            slots[6],
                            style: GoogleFonts.comfortaa(
                              color: isSelected[i][6]?Colors.white:Color(0xFF52b69a),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected[i][6]?Color(0xFF52b69a):Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (){
                            if (!isSelected[i][7]) {
                              isSelected[i][7] = true;
                            } else {
                              isSelected[i][7] = false;
                            }
                            setState((){});
                          },
                          child: Text(
                            slots[7],
                            style: GoogleFonts.comfortaa(
                              color: isSelected[i][7]?Colors.white:Color(0xFF52b69a),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected[i][7]?Color(0xFF52b69a):Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (){
                            if (!isSelected[i][8]) {
                              isSelected[i][8] = true;
                            } else {
                              isSelected[i][8] = false;
                            }
                            setState((){});
                          },
                          child: Text(
                            slots[8],
                            style: GoogleFonts.comfortaa(
                              color: isSelected[i][8]?Colors.white:Color(0xFF52b69a),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected[i][8]?Color(0xFF52b69a):Colors.white,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
            )
          )
      );
    }

    return new Column(children: list);
  }

  Widget build(BuildContext context) {

    return Scaffold(
      drawer: SideBar(),
      appBar: Header(
        appBar: AppBar(),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  getSlotList(),
                  Text(
                    errorText,
                    style: GoogleFonts.comfortaa(
                      fontSize: 10,
                      color: Colors.red,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: ((){
                        List<List<String>> addedSlots = <List<String>>[];
                        for (var i = 0; i < isSelected.length; i++) {
                          addedSlots.add([]);
                          for (var j = 0; j < slots.length; j++) {
                            if (isSelected[i][j])
                              addedSlots[i].add(slots[j]);
                          }
                          if ((i == 0 || i == isSelected.length-1) && addedSlots[i].length == 0){
                            errorText = "You must enter at least one slot in the first and last day!";
                            setState(() {});
                            return;
                          }
                        }

                        for (var i = 0; i < addedSlots.length; i++) {
                          if (addedSlots[i].length != 0) {
                            event["day" + (i+1).toString()] = addedSlots[i];
                          }
                        }

                        database.push().set(event);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                          return MyHomePage();
                        }));
                      }),
                      child: Text(
                        "Post Event",
                        style: GoogleFonts.comfortaa(),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF52b69a),
                      ),
                  )
                ],
              )
            ),
        ),
      ),
    );
  }
}

