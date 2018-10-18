import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'global_scoped_model.dart';
import '../enums.dart';


class UserScopedModel extends Model with  GlobalScopedModel{

  UserState userState = UserState.loggedOut;

  String _username;
  int _userId;
  bool _isActive = false;
  User user;

  set username(String username){
     _username = username;
  }

  set userId(int userId){
    _userId = userId;
  }

  set isActive(bool isActive){
    _isActive = isActive;
    notifyListeners();
  }

  bool get getIsActive => _isActive;

  String get getUsername => _username;

  int get getUserId => _userId;

  void createUser(){
     user = User(username: _username, userId: _userId, loggedInStatus: _isActive);
  }

  Future<void> getLogin(String username, String password, BuildContext context)  {
    return http.get("http://10.0.2.2/to_do/login.php?username=$username&password=$password")
        .then((response){
      var data = response.body;
      Map<String, dynamic> convertedData = jsonDecode(data);
      //print('this is converted data = $convertedData');
      _userId = int.parse(convertedData['result'][0]['id']);
      _username = convertedData['result'][0]['username'];
      _isActive = true;
      getFromServerNotes(_userId);
      userState = UserState.loggedIn;
      print(userState);
      Navigator.pushReplacementNamed(context, "/home_screen");
    }).catchError((error){
      print(error);
    });
  }

  void logOut(BuildContext context){
    userState = UserState.loggedOut;
    Navigator.pushReplacementNamed(context, "/login_screen");
  }

}