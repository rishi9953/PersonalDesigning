import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://img.favpng.com/8/20/24/computer-icons-online-shopping-png-favpng-QuiWDXbsc69EE92m3bZ2i0ybS.jpg'),
                    backgroundColor: Colors.red,
                    radius: 70,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              width: 300,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Login'),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 300,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Sign Up'),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
