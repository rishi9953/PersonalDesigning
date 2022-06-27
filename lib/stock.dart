// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<Color> color = [Colors.blue, Colors.red, Colors.orange, Colors.green];

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Container(
            color: Colors.orangeAccent,
            height: 100,
            child: Row(
              children: [
                Container(
                    child: Image.network(
                        'https://cdn0.iconfinder.com/data/icons/micro8/100/micro8icons-go-28-512.png',
                        height: 60,
                        width: 40)),
                SizedBox(width: _width * 0.03),
                Text('MR KnowIT Stockist',
                    style: TextStyle(color: Colors.white)),
                Spacer(),
                Container(
                    height: _height * 0.07,
                    width: 200,
                    child: Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUYdrji4Be_PT5xARS4qTH8qfaBoW78qRoZw&usqp=CAU')),
              ],
            ),
          ),
          Container(
              height: 30,
              color: Colors.red,
              child: Row(children: [
                Text('Welcome Rishabh kumar',
                    style: TextStyle(color: Colors.white)),
                Spacer(),
                TextButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.logout, color: Colors.white),
                    label:
                        Text('Logout', style: TextStyle(color: Colors.white)))
              ])),
          Container(
              height: 200,
              width: 200,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: color[index])),
                        height: 400,
                        width: 300,
                        child: Center(child: Text('Hello'))),
                  );
                },
              )),
        ],
      ),
    ));
  }
}
