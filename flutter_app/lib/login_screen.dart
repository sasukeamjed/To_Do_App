import 'package:flutter/material.dart';
import 'auth/user_methods.dart';
import 'package:scoped_model/scoped_model.dart';
import 'scoped_model/user_scoped_model.dart';

class LoginScreen extends StatelessWidget {

  final UserMethods userMethods = new UserMethods();

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
            ScopedModelDescendant<UserScopedModel>(builder: (BuildContext context, Widget child, UserScopedModel model){
              return FlatButton(
                child: Text('Log In'),
                onPressed: (){
                  //createUser();
                  model.getLogin(username.text, password.text, context);
                },
              );
            },),
          ],
        ),
      ),
    );
  }


}
