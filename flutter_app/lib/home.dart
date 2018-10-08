import 'package:flutter/material.dart';
import 'model/note_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'scoped_model/user_scoped_model.dart';

class HomeScreen extends StatefulWidget {

  UserScopedModel userScopedModel = UserScopedModel();

  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  var editMode = false;
  var noteController = TextEditingController();

  bool taskIsDone = false;

  List<Note> notes = new List();

  @override
  void initState() {
    notes.clear();
    widget.userScopedModel.getNotes(widget.userScopedModel.getUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ScopedModelDescendant<UserScopedModel>(
          builder: (BuildContext context, Widget child, UserScopedModel model) {
            return Text('${model.getUsername}');
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          ScopedModelDescendant<UserScopedModel>(
            builder:
                (BuildContext context, Widget child, UserScopedModel model) {
              return IconButton(
                icon: Icon(
                  Icons.add,
                ),
                onPressed: () {
                  setState(() {
                    editMode = !editMode;
                    if (editMode == false) {
                      if (noteController.text.isEmpty) {
                        print("there is nothing to add");
                        widget.userScopedModel.deleteNotes(notes);
                        return null;
                      } else {
                        notes.add(Note(note: noteController.text));
                        model.addNoteToDb(model.getUserId, noteController.text);
                        model.getNotes(model.getUserId);
                        model.deleteNotes(notes);
                        //noteController.clear();
                        //print(notes);
                      }
                    } else {
                      noteController.clear();
                    }
                    print(editMode);
                  });
                },
              );
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
                  title: Text(notes[index].note),
                  trailing: Checkbox(
                      value: notes[index].taskIsDone,
                      onChanged: (bool mode) {
                        setState(() {
                          notes[index].taskIsDone = mode;
                        });
                      }),
                ),
                Divider(),
              ],
            );
          });
    }
  }
}
