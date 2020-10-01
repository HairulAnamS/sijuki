import 'package:flutter/material.dart';

class TestingPage extends StatefulWidget {
  @override
  _TestingPageState createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  TextEditingController controllerComment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // resizeToAvoidBottomPadding: true,
        // floatingActionButton: Container(

        // )
        bottomSheet: Container(
          padding: EdgeInsets.all(5),
          //height: 50,
          color: Colors.teal,
          child: TextField(
            controller: controllerComment,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Komentar disini...'),
          ),
        ),
      ),
    );
  }
}
