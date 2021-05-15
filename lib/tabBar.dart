import 'package:flutter/material.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.grid_on,
                  color: Colors.black,
                ),
              ),
              Tab(
                icon: Icon(Icons.assignment_ind, color: Colors.black),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Text('A'),
            Text('B'),
            Text('C'),
          ],
        ),
      ),
    );
  }
}
