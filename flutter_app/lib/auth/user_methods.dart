import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../home.dart';
import '../model/user_model.dart';

class UserMethods{



  Future<void> createUser(BuildContext context, String username, String password) async{
    await http.post("http://10.0.2.2/to_do/NewUser.php", body: {
      'username' : username,
      'password' : password,
    }).then((response){
      Map<String, dynamic> data = jsonDecode(response.body);
      switch(data['code']){
        case 1:{
          onSignUpIsComplete(context);
          Navigator.pushReplacementNamed(context,"/main_screen");
        }
        break;

        case 2: {
          onSignUpIsFailed(context);
        }
        break;

        case 3: {
          whenUserAlreadyExist(context);
        }
        break;
      }
    });
  }

  void onSignUpIsComplete(BuildContext context) {
    var alert = new AlertDialog(
      title: new Text("Signing up Completed"),
      content: new Text(
          "You can sign in now"),
    );
    showDialog(context: context, child: alert);
  }

  void onSignUpIsFailed(BuildContext context) {
    var alert = new AlertDialog(
      title: new Text("Signing up Failed"),
      content: new Text(
          "You can try again later"),
    );
    showDialog(context: context, child: alert);
  }

  void whenUserAlreadyExist(BuildContext context) {
    var alert = new AlertDialog(
      title: new Text("Signing up Failed"),
      content: new Text(
          "User Already exist"),
    );
    showDialog(context: context, child: alert);
  }
}