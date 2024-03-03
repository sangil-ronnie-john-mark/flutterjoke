import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main(){
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> joke = [];

  @override
  Future<void> jokeFunction() async {
    final url = 'https://v2.jokeapi.dev/joke/Any?safe-mode';
    final response = await http.get(
      Uri.parse(url),
    );

    setState(() {
      print(response.body);
      if (response.statusCode == 200) {
        joke = [jsonDecode(response.body)];
      } else {
        joke = [];
        print('2');
      }
    });


  }
  void initState() {
    setState(() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        jokeFunction();
      });
    });

    });
    super.initState();
  }
  @override
  Widget buildJokes(BuildContext context, int index, data) {

    return data.containsKey('setup')
        ? Column(
      children: [
        Text(data['setup'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        Text(data['delivery'])
      ],
    )
        : Column(
      children: [
        CircularProgressIndicator(),
        Text('Loading'),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joke App'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: joke.isNotEmpty? joke.asMap().entries.map((e) => buildJokes(context, e.key, e.value)).toList():
          [
           Column(
              children: [
                CircularProgressIndicator(),
                Text('Loading')
              ],
            )
          ],
        ),
      ),
    );
  }
}
