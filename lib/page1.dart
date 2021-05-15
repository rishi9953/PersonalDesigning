import 'package:flutter/material.dart';
import 'package:personal_designing/tabBar.dart';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Username',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            Icon(
              Icons.add_box_outlined,
              color: Colors.black,
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.person_add_sharp,
              color: Colors.black,
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.menu,
              color: Colors.black,
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(
                    alignment: Alignment(1, 1),
                    children: [
                      Container(
                        child: InkWell(
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: SizedBox(
                                width: 130,
                                height: 130,
                                child: Image.network(
                                  "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text("100", style: Theme.of(context).textTheme.headline6),
                      Text('Posts'),
                    ],
                  ),
                  Column(
                    children: [
                      Text("2k", style: Theme.of(context).textTheme.headline6),
                      Text('Followers'),
                    ],
                  ),
                  Column(
                    children: [
                      Text("234", style: Theme.of(context).textTheme.headline6),
                      Text('Following'),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Rishabh kumar'),
                      ],
                    ),
                    Row(
                      children: [Text('Live and let live....')],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black38),
                  ),
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
