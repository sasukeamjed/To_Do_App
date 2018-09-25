import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(new MyApp());

enum userStatus {
  loggedIn,
  LoggedOut,
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final username = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('To Do App'),
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
              child: Text('Register a New User'),
              onPressed: (){
                createUser();
                //getLogin(username.text, password.text);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Future<List> createUser() async{
    var result = await http.post("http://10.0.2.2/to_do/NewUser.php", body: {
      'username' : username.text,
      'password' : password.text,
    }).then((response){
      print(response.body);
    });
  }

  Future<String> getLogin(String username, String password) async {
    var response = await http.get("http://10.0.2.2/to_do/login.php?username=${username}&password=${password}");
    var data = response.body;
    Map<String, dynamic> convertedData = jsonDecode(data);
    print('this is converted data = ${convertedData}');
  }
}
