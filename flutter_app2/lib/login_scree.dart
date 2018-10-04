import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'dart:convert';

class MainScreen extends StatelessWidget {

  final username = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log in'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: username,
              decoration: InputDecoration(
                  hintText: 'Example@example.com',
                  labelText: 'Email'
              ),
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
              ),
            ),
            FlatButton(
              child: Text('Log In'),
              onPressed: (){
                //createUser();
                getLogin(username.text, password.text, context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getLogin(String username, String password, BuildContext context) async {
    await http.get("http://10.0.2.2/to_do/login.php?username=${username}&password=${password}")
    .then((response){
      var data = response.body;
      Map<String, dynamic> convertedData = jsonDecode(data);
      print('this is converted data = ${convertedData}');
      print(convertedData['result'][0]['id']);
      Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen(convertedData['result'][0]['username'])));
    }).catchError((error){
      print(error);
    });
  }
}
