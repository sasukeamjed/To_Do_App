import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../model/note_model.dart';
import '../model/user_model.dart';

class UserScopedModel extends Model {

  String _username;
  int _userId;
  bool _isActive = false;
  User user;

  List<Note> _notes = [];

  List<Note> get notes {
    return List.from(_notes);
  }

  set username(String username){
     _username = username;
  }

  set userId(int userId){
    _userId = userId;
  }

  set isActive(bool isActive){
    _isActive = isActive;
  }

  bool get getIsActive => _isActive;

  String get getUsername => _username;

  int get getUserId => _userId;

  void createUser(){
     user = User(username: _username, userId: _userId, loggedInStatus: _isActive);
  }

  Future<Null> addNoteToDb(int userId, String note) async {
    print("this is the note $note");
    return http.post("http://10.0.2.2/to_do/note_data.php", body: {
      "note": note,
      "userId": userId.toString(),
    }).then((result) {
      print(result.body);
    });
  }

  Future<void> getNotes(int userId) async {
    http
        .get("http://10.0.2.2/to_do/get_notes.php?userId=${userId.toString()}")
        .then((response) {
      Map<String, dynamic> map = jsonDecode(response.body);
      print('this is the map: $map');
      notes.clear();
      map["array"].forEach((map) => notes.add(Note(
          noteId: int.parse(map["noteId"]),
          note: map["note"],
          userId: userId)));
    });
  }

  List<Note> deleteNotes(List<Note> notes) {
    notes.forEach((note) {
      if (note.taskIsDone) {
        http
            .get(
            "http://10.0.2.2/to_do/remove_note.php?noteId=${note.noteId.toString()}")
            .then((response) {
          print(response.body);
          Map<String, dynamic> map = jsonDecode(response.body);
          if (map["code"] == "1") {
            notes.remove(note);
          } else {
            print("delete failed");
          }
        });
      } else {
        print("there is no notes to delete");
      }
    });
    return notes;
  }

  Future<void> getLogin(String username, String password, BuildContext context) async {
    await http.get("http://10.0.2.2/to_do/login.php?username=$username&password=$password")
        .then((response){
      var data = response.body;
      Map<String, dynamic> convertedData = jsonDecode(data);
      //print('this is converted data = $convertedData');
      _userId = int.parse(convertedData['result'][0]['id']);
      _username = convertedData['result'][0]['username'];
      _isActive = true;
      getNotes(_userId);
      Navigator.pushReplacementNamed(context, "/home_screen");
    }).catchError((error){
      print(error);
    });
  }

}