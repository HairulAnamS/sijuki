import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TabPosting extends StatefulWidget {
  final FirebaseUser userLogin;
  final Color colorku;
  const TabPosting({
    Key key,
    @required this.userLogin,
    @required this.colorku,
  }) : super(key: key);

  @override
  _TabPostingState createState() => _TabPostingState();
}

class _TabPostingState extends State<TabPosting> {
  @override
  Widget build(BuildContext context) {
    print(widget.colorku);
    return Container(
      height: 500,
      color: widget.colorku,
      child: Text(widget.userLogin.toString()),

    );
    // return ListView(
    //   children: [
    //     Text('data 1'),
    //     Text('data 2'),
    //     Text('data 3'),
    //     Text('data 4'),
    //     Text('data 5'),
    //     Text('data 6'),
    //     Text('data 1'),
    //     Text('data 2'),
    //     Text('data 3'),
    //     Text('data 4'),
    //     Text('data 5'),
    //     Text('data 6'),
    //   ],
    // );
  }
}
