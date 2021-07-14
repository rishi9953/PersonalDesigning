import 'package:flutter/material.dart';
import 'package:personal_designing/FirstPage.dart';
// import 'package:personal_designing/newpage.dart';
// import 'package:personal_designing/page1.dart';

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
