import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'scoped_model/main.dart';
import 'home.dart';
import 'register.dart';
import 'enums.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        if (model.userState == UserState.loggedIn) {
          return HomeScreen();
        } else if (model.userState == UserState.loggedOut) {
          return RegisterPage();
        }
      },
    );
  }
}
