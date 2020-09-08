import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final List<String> _str = [
    'aku',
    'aku kamu dia bapakmu adikmu ibumu dan juga keluargamu',
    'Jika sebuah penampung hanya memiliki satu turunan tingkat atas, Anda dapat menentukan properti penyelarasan untuk anak tersebut dan memberikan nilai yang tersedia. itu akan mengisi semua ruang di wadah.'
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _str.length,
      itemBuilder: (_, index) {
        var str = _str[index];
        return Container(
          margin: EdgeInsets.all(5),
          color: Colors.blueAccent,
          padding: EdgeInsets.all(10),
          // constraints:  BoxConstraints.expand(height: double.infinity),
          // height: 100,
          child: Text(str),
        );
      },
    );
  }
}
