import 'package:flutter/material.dart';

class MyNewPage extends StatelessWidget {
  const MyNewPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        color: Colors.purple,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 50,
              top: 60,
              child: Image.asset(
                'assets/images/pngwing.com.png',
                height: MediaQuery.of(context).size.height * 0.6,
              ),
            ),
            Positioned(
              bottom: 160,
              child: Text(
                'Adding Fun to Your Life',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              bottom: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {},
                child: Container(
                    width: 250,
                    height: 50,
                    child: Center(child: Text('Get Started'))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
