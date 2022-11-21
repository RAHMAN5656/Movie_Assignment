import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Movie Trick'),
        ),
        body: const Homepage(
          title: '',
        ),
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key, required this.title});
  final String title;
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var description = "", title = "";
  String search = "";
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Movie Investigation",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber)),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Search movie',
              hintText: 'Search movie here',
            ),
            onChanged: (text) {
              setState(() {
                search = text;
              });
            },
          ),
          ElevatedButton(
              onPressed: _getGenre, child: const Text("Find Your Liking")),
          Text(description,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
        ],
      ),
    );
  }

  Future<void> _getGenre() async {
    AlertDialog alert = AlertDialog(
      content: Row(children: [
        CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
        Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
      ]),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    var apikey = "3778ba92";
    var url = Uri.parse('https://www.omdbapi.com/?t=$search&apikey=$apikey');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200 && search.isNotEmpty) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        var title = parsedJson["Title"];
        var genre = parsedJson["Genre"];
        var year = parsedJson["Year"];
        var descs = parsedJson["Plot"];
        var poster = parsedJson["Poster"];
        Navigator.pop(context);
        description =
            "What You Are Looking For $search shows $title \n\nThis movie genre is $genre out in $year.\n\n$descs\n\nClick link to view image\n$poster";
      });
    } else {
      setState(() {
        Navigator.pop(context);
        description = "Oops, What You Are Searching For Is Gone";
      });
    }
  }
}
