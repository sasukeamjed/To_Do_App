import 'package:flutter/material.dart';
import 'auth/user_methods.dart';

class RegisterPage extends StatelessWidget {

  final UserMethods userMethods = UserMethods();

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
                    userMethods.createUser(context, username.text, password.text);
                    //getLogin(username.text, password.text);
                  },
                ),
                FlatButton(
                  child: Text('Log in'),
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, "/login_screen");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
