import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(
      MaterialApp(
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Post> post;

  @override
  void initState() {
    super.initState();
    post = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text ('My App'),),
      body: SafeArea(
        child: FutureBuilder<Post>(
          future: post,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Card(
                borderOnForeground: true,
                color: Colors.blue[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 10.0,
                child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.account_circle, size: 50),
                      title: Text("User Data", style: new TextStyle(
                        fontSize: 50,
                      )),
                      subtitle: Text(snapshot.data.title, style: new TextStyle(
                        fontSize: 25,
                      )),
                    ),

                  ],
                )
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

Future<Post> fetchPost() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200)
    return Post.fromMap(json.decode(response.body));
  else
    throw Exception('Failed to load post');
}

class Post {
  int userId = 0;
  int id = 0;
  String title = '';
  String completed = '';

  Post({this.userId, this.id, this.title, this.completed});

  factory Post.fromMap(Map<String, dynamic> map) {
    return new Post(
      userId: map['userId'] as int,
      id: map['id'] as int,
      title: map['title'] as String,
      completed: map['completed'] as String,
    );
  }
}
