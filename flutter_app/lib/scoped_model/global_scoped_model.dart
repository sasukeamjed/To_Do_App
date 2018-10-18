import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../model/note_model.dart';

class GlobalScopedModel extends Model {
  List<Note> _notes = [];

  List<Note> get getOrginalNotes {
    return List.from(_notes);
  }

//  List<String> get getShortNotes{
//    return cuttingTheText(List.from(_notes));
//  }

  Future<void> addNoteToDb(int userId, String note) {
    print("this is the note $note");
    return http.post("http://10.0.2.2/to_do/note_data.php", body: {
      "note": note,
      "userId": userId.toString(),
    }).then((result) {
      print(result.body);
      getFromServerNotes(userId);
      notifyListeners();
    });
  }

  Future<void> updateNote(Note note, String updatedNote) {
    return http.post("http://10.0.2.2/to_do/update_note.php", body: {
      "noteId": note.noteId.toString(),
      "updatedNote": updatedNote,
    }).then((response) {
      print(response.body);
      Map<String, dynamic> map = jsonDecode(response.body);
      print(map);
      note.note = updatedNote;
      notifyListeners();
    });
  }

  Future<void> getFromServerNotes(int userId) {
    _notes.clear();
    http
        .get("http://10.0.2.2/to_do/get_notes.php?userId=${userId.toString()}")
        .then((response) {
      Map<String, dynamic> map = jsonDecode(response.body);
      print('this is the map: $map');
      _notes.clear();
      map["array"].forEach((map) {
        print('adding note');
        return _notes.add(Note(
            noteId: int.parse(map["noteId"]),
            note: map["note"],
            userId: userId));
      });
      notifyListeners();
    });

    _notes.forEach((note) {
      print(note.note);
    });
    return;
  }

  List<Note> deleteNotes() {
    _notes.forEach((note) {
      if (note.taskIsDone) {
        http
            .get(
                "http://10.0.2.2/to_do/remove_note.php?noteId=${note.noteId.toString()}")
            .then((response) {
          print(response.body);
          Map<String, dynamic> map = jsonDecode(response.body);
          if (map["code"] == "1") {
            _notes.remove(note);
            notifyListeners();
          } else {
            print("delete failed");
          }
        });
      } else {
        print("there is no notes to delete");
      }
    });
    return _notes;
  }

  String cuttingTheText(int wordsLimit, int charLimit, String note) {
    //List<String> noteList = [];
    String finalText;
    var list = [];
    list = note.split(" ");
    //String finalText;
    if(wordsLimit > list.length){
      return finalText = list.join(" ");
    }
    else if (list.length >= wordsLimit) {
      list.removeRange(wordsLimit, list.length);
      return finalText = list.join(" ");
    } else if (list.length == 1) {
      if (note.length >= charLimit) {
        return finalText = note.replaceRange(charLimit, note.length, "...");
      } else {
        return finalText = note;
      }
    } else if (list.length <= 2) {
      return finalText = list.join(" ");
    }
    //noteList.add(finalText);

    return finalText;
  }
}
