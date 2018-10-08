import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'scoped_model/user_scoped_model.dart';
import 'home.dart';
import 'register.dart';

class Root extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserScopedModel>(
      builder: (BuildContext context, Widget child, UserScopedModel model){
        if(model.getIsActive){
          return HomeScreen();
        }else {
          return RegisterPage();
        }
      },
    );
  }
}
