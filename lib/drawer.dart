import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool wide = false;

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          wide = !wide;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 1000),
        height: _height,
        width: wide ? _width * 0.7 : _width * 0.2,
        color: Colors.red,
      ),
    );
  }
}
