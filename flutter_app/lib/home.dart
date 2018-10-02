import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  String username;

  HomeScreen(this.username);

  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  var editMode = false;
  var noteController = TextEditingController();

  var notes = new List();

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
                    noteController.clear();
                    print(notes);
                  }
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
            : listNotesBuilder(),
      ),
    );
  }

  Widget listNotesBuilder() {
    Widget list = Text('There is not items available');

    if (notes.isEmpty) {
      return list;
    } else {
      list = ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index]),
          );
        },
      );
    }
    return list;
  }
}
