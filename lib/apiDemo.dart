import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future senData() async {
  final http.Response response = await http.post(
      Uri.parse('https://fakestoreapi.com/products'),
      headers: <String, String>{
        'content-type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'title': 'Rishabh',
        'id': '21',
        'image': '',
        'description': 'hello this is Rishabh'
      }));
  if (response.statusCode == 200) {
    Album.fromJson(json.decode(response.body));
    print(response.body);
    print(response.statusCode);
  } else {
    throw Exception('Failed to send the data');
  }
}

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

updateAlbum(String? title, int? id) async {
  final http.Response response = await http.put(
    Uri.parse("https://fakestoreapi.com/products/$id"),
    headers: <String, String>{
      'content-type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title!,
    }),
  );
  if (response.statusCode == 200) {
    Album.fromJson(json.decode(response.body));
    print(response.body);
    print(response.statusCode);
  } else {
    throw Exception('Failed to update');
  }
}

deleteAlbum(int id) async {
  final http.Response response = await http.delete(
      Uri.parse('https://fakestoreapi.com/products/$id'),
      headers: <String, String>{
        'content-type': 'application/json; charset=UTF-8'
      });
  if (response.statusCode == 200) {
    Album.fromJson(json.decode(response.body));
    print(response.body);
    print(response.statusCode);
  } else {
    throw Exception('Failed to delete');
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
      debugShowCheckedModeBanner: false,
      title: 'Fetching Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              Container(
                height: 100,
                color: Colors.red,
                child: ListTile(
                    leading: CircleAvatar(
                      child: Image.network(
                          'https://image.shutterstock.com/image-vector/man-icon-vector-260nw-1040084344.jpg'),
                    ),
                    title: Text('Rishabh kumar'),
                    subtitle: Text('rk@gmail.com')),
              ),
              ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Get Data'),
                  trailing: Icon(Icons.arrow_forward_ios)),
              Divider(),
              ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Update Data'),
                  trailing: Icon(Icons.arrow_forward_ios)),
              Divider(),
              ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Delete Data'),
                  trailing: Icon(Icons.arrow_forward_ios)),
              Divider(),
              ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Post Data'),
                  trailing: Icon(Icons.arrow_forward_ios)),
              Divider(),
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text('API Demo', style: Theme.of(context).textTheme.headline6),
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
                            trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  deleteAlbum(snapshot.data![index].id!);
                                }),
                            onTap: () {
                              updateAlbum(snapshot.data![index].title,
                                  snapshot.data![index].id);
                            }),
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
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              senData();
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
