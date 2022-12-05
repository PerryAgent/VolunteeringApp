import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './header.dart';
import './home_page.dart';
import './sideBar.dart';

class AddEvent extends StatefulWidget{

  AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {

  final database = FirebaseDatabase.instance.ref().child('Event/');
  final _user = FirebaseAuth.instance.currentUser!;
  List<TextEditingController> _controller = List.generate(4, (index) => TextEditingController());
  List<bool> _validate = List.generate(3, (index) => true);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: SideBar(),
      appBar: Header(
        appBar: AppBar(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Enter your event details", style: GoogleFonts.comfortaa(
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)
            ),),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.event),
                hintText: "Event Name",
                errorText: !_validate[0] ? "This is a required field" : null,
              ),
              controller: _controller[0],
            ),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.event_note),
                hintText: "Event Details",
                errorText: !_validate[1] ? "This is a required field" : null,
              ),
              controller: _controller[1],
            ),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.calendar_today),
                hintText: "Date of event",
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
                  String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                  _controller[2].text = formattedDate;
                  setState(() {});
                }
              },
            ),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.people),
                hintText: "Number of people required",
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly], // Only numbers can
              controller: _controller[3],
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
                 if (required == _validate.length) {
                   Map<String, String> newEvent = {
                     'userName': _user.displayName!,
                     'email': _user.email!,
                     'eventName': _controller[0].text,
                     'eventDetails': _controller[1].text,
                     'eventDate': _controller[2].text,
                     'numberOfPeople': _controller[3].text,
                     'dateOfUpload': DateFormat('dd-MM-yyyy').format(DateTime.now()),
                   };
                   database.push().set(newEvent);
                   Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                     return MyHomePage();
                   }));
                 }
                },
               child: Text(
                "Post",
                style: GoogleFonts.comfortaa(),
               ),
               style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF52b69a),
              ),
            )
          ],
        ),
      ),
    );
  }
}
