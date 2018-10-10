import 'package:flutter/material.dart';
import 'model/note_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'scoped_model/user_scoped_model.dart';

class HomeScreen extends StatefulWidget {
  final UserScopedModel userScopedModel = UserScopedModel();

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
                        model.deleteNotes();
                        return null;
                      } else {
                        widget.userScopedModel.getNotes
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
      ),
      body: Center(
        child: ScopedModelDescendant<UserScopedModel>(
          builder: (BuildContext context, Widget child, UserScopedModel model) {
            return editMode
                ? TextField(
                    controller: noteController,
                    autofocus: true,
                  )
                : model.getNotes.isEmpty
                    ? Text('There is not items available')
                    : ListView.builder(
                        itemCount: model.getNotes.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(model.getNotes[index].note),
                                trailing: Checkbox(
                                    value: model
                                        .getNotes[index].taskIsDone,
                                    onChanged: (bool mode) {
                                      setState(() {
                                        model.getNotes[index]
                                            .taskIsDone = mode;
                                      });
                                    }),
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

  Widget listNotesBuilder(BuildContext context) {
    if (widget.userScopedModel.getNotes.isEmpty) {
      print('list is empty');
      return Text('There is not items available');
    } else {
      print('there is items on the list');
      return ListView.builder(
          itemCount: widget.userScopedModel.getNotes.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(widget.userScopedModel.getNotes[index].note),
                  trailing: Checkbox(
                      value: widget.userScopedModel.getNotes[index].taskIsDone,
                      onChanged: (bool mode) {
                        setState(() {
                          widget.userScopedModel.getNotes[index].taskIsDone =
                              mode;
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
