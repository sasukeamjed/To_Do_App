import 'package:flutter/material.dart';
import 'model/note_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'scoped_model/main.dart';
import 'note_viewer.dart';
import 'enums.dart';

class HomeScreen extends StatefulWidget {
  //final MainModel userScopedModel = MainModel();

  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  var editMode = false;
  var noteController = TextEditingController();

  bool taskIsDone = false;

  @override
  void initState() {
    //widget.userScopedModel.getNotes;
    //widget.userScopedModel.getFromServerNotes(widget.userScopedModel.getUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            return Text('${model.getUsername}');
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
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
                        model.deleteNotes();
                        return null;
                      } else {
                        model.getOrginalNotes
                            .add(Note(note: noteController.text));
                        model.addNoteToDb(model.getUserId, noteController.text);
                        //model.getFromServerNotes(model.getUserId);
                        model.deleteNotes();
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
        leading: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: ScopedModelDescendant(
              builder: (BuildContext context, Widget child, MainModel model) {
            return FlatButton(
              onPressed: () {
                model.logOut(context);
              },
              child: Text(
                'Log Out',
                style: TextStyle(fontSize: 10.0),
              ),
            );
          }),
        ),
      ),
      body: Center(
        child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            return editMode
                ? GestureDetector(
                    child: TextField(
                      controller: noteController,
                      autofocus: true,
                    ),
                    onTap: () {
                      print("Edit Text is tapped");
                    },
                  )
                : model.getOrginalNotes.isEmpty
                    ? Text('There is no items available')
                    : ListView.builder(
                        itemCount: model.getOrginalNotes.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  model.cuttingTheText(
                                      3, 20, model.getOrginalNotes[index].note),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  model.cuttingTheText(
                                      8, 25, model.getOrginalNotes[index].note),
                                  style: TextStyle(color: Colors.grey),
                                ),
                                trailing: Checkbox(
                                    value:
                                        model.getOrginalNotes[index].taskIsDone,
                                    onChanged: (bool mode) {
                                      setState(() {
                                        model.getOrginalNotes[index]
                                            .taskIsDone = mode;
                                      });
                                    }),
                                onTap: () {
                                  onNoteClicked(index, model.getOrginalNotes);
                                },
                              ),
                              Divider(),
                            ],
                          );
                        });
          },
        ),
      ),
    );
  }

//model.getShortNotes[index]

//  Widget listNotesBuilder(BuildContext context) {
//    if (widget.userScopedModel.getNotes.isEmpty) {
//      print('list is empty');
//      return Text('There is not items available');
//    } else {
//      print('there is items on the list');
//      return ListView.builder(
//          itemCount: widget.userScopedModel.getNotes.length,
//          itemBuilder: (context, index) {
//            return Column(
//              children: <Widget>[
//                ListTile(
//                  title: Text(widget.userScopedModel.getNotes[index].note),
//                  trailing: Checkbox(
//                      value: widget.userScopedModel.getNotes[index].taskIsDone,
//                      onChanged: (bool mode) {
//                        setState(() {
//                          widget.userScopedModel.getNotes[index].taskIsDone =
//                              mode;
//                        });
//                      }),
//                ),
//                Divider(),
//              ],
//            );
//          });
//    }
//  }

  onNoteClicked(int index, List<Note> notes) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteViewer(note: notes[index]);
    }));
  }
}
