import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  String username;

  HomeScreen(this.username);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('$username'),
      ),
    );
  }
}
