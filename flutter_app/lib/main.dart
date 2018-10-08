import 'package:flutter/material.dart';
import 'root.dart';
import 'login_screen.dart';
import 'register.dart';
import 'home.dart';
import 'package:scoped_model/scoped_model.dart';
import 'scoped_model/user_scoped_model.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserScopedModel>(
      model: UserScopedModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new Root(),
        routes: {
          "/login_screen": (context) => LoginScreen(),
          "/register_screen": (context) => RegisterPage(),
          "/home_screen": (context) => HomeScreen(),
        },
      ),
    );
  }
}
