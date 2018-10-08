import 'package:flutter/foundation.dart';

class Note {
  Note({ this.noteId,
    this.note,
    this.userId,
    this.taskIsDone = false,});


  int noteId;
  String note;
  int userId;
  bool taskIsDone;
}