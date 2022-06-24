import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Album>> fetchAlbum() async {
  final response =
      await http.get(Uri.parse('https://fakestoreapi.com/products'));

  // Appropriate action depending upon the
  // server response
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new Album.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load album');
  }
}

class Album {
  final int? id;
  final double? price;
  final String? title;
  final String? image;
  final String? description;
  Album({this.id, this.title, this.image, this.price, this.description});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        id: json['id'],
        title: json['title'],
        image: json['image'],
        description: json['description'],
        price: json['price']);
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<Album>>? futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetching Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Api Demo'),
        ),
        body: FutureBuilder<List<Album>>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Album> data = snapshot.data!;
              return ListView.separated(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                            leading: Text('${snapshot.data![index].id ?? ''}'),
                            title: Text('${snapshot.data![index].title ?? ''}'),
                            subtitle: Text(
                                '${snapshot.data![index].description ?? ''}'),
                            trailing: Image.network(
                                '${snapshot.data![index].image}')),
                      ));
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
