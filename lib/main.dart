import 'package:flutter/material.dart';
import 'package:personal_designing/FirstPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Personal Designing",
      home: FirstPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
