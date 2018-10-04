import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  String username;
  int userId;

  HomeScreen(this.username, this.userId);

  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  var editMode = false;
  var noteController = TextEditingController();

  bool taskIsDone = false;

  List<String> notes = new List();

  @override
  void initState() {
    notes.clear();
    getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.username}'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () {
              setState(() {
                editMode = !editMode;
                if (editMode == false) {
                  if (noteController.text.isEmpty) {
                    print("there is nothing to add");
                    return null;
                  } else {
                    notes.add(noteController.text);
                    addNoteToDb();
                    getNotes();
                    //noteController.clear();
                    //print(notes);
                  }
                }else{
                  noteController.clear();
                }
                print(editMode);
              });
            },
          ),
        ],
      ),
      body: Center(
        child: editMode
            ? TextField(
                controller: noteController,
                autofocus: true,
              )
            : listNotesBuilder(context),
      ),
    );
  }

  Widget listNotesBuilder(BuildContext context) {
    if (notes.isEmpty) {
      print('list is empty');
      return Text('There is not items available');
    } else {
      print('there is items on the list');
      return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(notes[index]),
                  trailing: Checkbox(
                      value: taskIsDone,
                      onChanged: (mode) {
                        setState(() {
                          taskIsDone = mode;
                        });
                      }),
                ),
                Divider(),
              ],
            );
          });
    }
  }

  Future<Null> addNoteToDb() async {
    print("this is the note ${noteController.text}");
    return http.post("http://10.0.2.2/to_do/note_data.php", body: {
      "note": noteController.text,
      "userId": widget.userId.toString(),
    }).then((result) {
      print(result.body);
    });
  }

  Future<List> getNotes({BuildContext context}) async {
    http.get("http://10.0.2.2/to_do/get_notes.php?userId=${widget.userId}").then((response) {
      Map<String, dynamic> map = jsonDecode(response.body);
      print(response.body);
      notes.clear();
      map["array"].forEach((map) => notes.add(map["note"]));
    }).whenComplete(() {
      setState(() {
        listNotesBuilder(context);
      });
    });
  }
}
