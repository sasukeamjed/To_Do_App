import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'scoped_model/main.dart';
import 'model/note_model.dart';
import 'package:share/share.dart';

class NoteViewer extends StatefulWidget {
  final Note note;

  NoteViewer({this.note});

  @override
  _NoteViewerState createState() => _NoteViewerState();
}

class _NoteViewerState extends State<NoteViewer> {
  MainModel model = MainModel();

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.note.note;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note"),
        actions: <Widget>[
          new Builder(
            builder: (BuildContext context) {
              return new IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  print('share is pressed');
                  // A builder is used to retrieve the context immediately
                  // surrounding the RaisedButton.
                  //
                  // The context's `findRenderObject` returns the first
                  // RenderObject in its descendent tree when it's not
                  // a RenderObjectWidget. The RaisedButton's RenderObject
                  // has its position and size after it's built.
                  final RenderBox box = context.findRenderObject();
                  Share.share(_controller.text,
                      sharePositionOrigin:
                      box.localToGlobal(Offset.zero) &
                      box.size);
                },
              );
            },
          ),
          ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
            return FlatButton(
              child: Text("Done"),
              onPressed: () {
                model.updateNote(widget.note, _controller.text);
              },
            );
          }),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: TextField(
          maxLines: 300,
          controller: _controller,
        ),
      ),
    );
  }
}
