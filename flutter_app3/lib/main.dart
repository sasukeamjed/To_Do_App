import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
//import 'login_screen.dart';

void main() => runApp(new MyApp());

enum UserStatus {
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
//      routes: {
//        "/login_screen" : (context) => MainScreen(),
//      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  UserStatus userCondition = UserStatus.LoggedOut;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text('Register a New User'),
                  onPressed: (){
                    createUser();
                    //getLogin(username.text, password.text);
                  },
                ),
                FlatButton(
                  child: Text('Log in'),
                  onPressed: (){
                    Navigator.pushNamed(context, "/login_screen");
                  },
                ),
              ],
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
      Map<String, dynamic> data = jsonDecode(response.body);
      switch(data['code']){
        case 1:{
          onSignUpIsComplete();
          Navigator.pushNamed(context, "/main_screen");
        }
        break;

        case 2: {
          onSignUpIsFailed();
        }
        break;

        case 3: {
          whenUserAlreadyexist();
        }
        break;
      }
    });
  }

  Future<String> getLogin(String username, String password) async {
    var response = await http.get("http://10.0.2.2/to_do/login.php?username=${username}&password=${password}");
    var data = response.body;
    Map<String, dynamic> convertedData = jsonDecode(data);
    print('this is converted data = ${convertedData}');
  }

  void onSignUpIsComplete() {
    var alert = new AlertDialog(
      title: new Text("Signing up Completed"),
      content: new Text(
          "You can sign in now"),
    );
    showDialog(context: context, child: alert);
  }

  void whenUserAlreadyexist() {
    var alert = new AlertDialog(
      title: new Text("Signing up Failed"),
      content: new Text(
          "User Already exist"),
    );
    showDialog(context: context, child: alert);
  }

  void onSignUpIsFailed() {
    var alert = new AlertDialog(
      title: new Text("Signing up Failed"),
      content: new Text(
          "You can try again later"),
    );
    showDialog(context: context, child: alert);
  }

  void onSignedInErrorPassword() {
    var alert = new AlertDialog(
      title: new Text("Pseudo Error"),
      content: new Text(
          "There was an Password error signing in. Please try again."),
    );
    showDialog(context: context, child: alert);
  }

  void onSignedInErrorPseudo() {
    var alert = new AlertDialog(
      title: new Text("Pseudo Error"),
      content:
      new Text("There was an Pseudo error signing in. Please try again."),
    );
    showDialog(context: context, child: alert);
  }



}
