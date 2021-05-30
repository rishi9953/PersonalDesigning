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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                'Welcome ',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 10),
              Text(
                'Automatic identify verification which enables you to verify your identify',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Image.asset('Assets/Images/5865.jpg'),
              // Stack(
              //   children: [
              //     Container(
              //       child: CircleAvatar(
              //         backgroundImage: NetworkImage(
              //             'https://img.favpng.com/8/20/24/computer-icons-online-shopping-png-favpng-QuiWDXbsc69EE92m3bZ2i0ybS.jpg'),
              //         backgroundColor: Colors.red,
              //         radius: 70,
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: Colors.black)),
                onPressed: () {},
                child: Container(
                  alignment: Alignment.center,
                  width: 250,
                  child: Text('Login'),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: Colors.black)),
                onPressed: () {},
                child: Container(
                  alignment: Alignment.center,
                  width: 250,
                  child: Text('Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
