import 'package:flutter/material.dart';
import 'package:sijuki/auth_services.dart';

class Alertku extends AlertDialog {
  static Future<void> showAlertCustom(BuildContext context, String aMessage) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('WARNING'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.warning_amber_rounded,
                  size: 70, color: Colors.yellow[900]),
              Text(aMessage)
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> alertLogout(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi', style: TextStyle(fontWeight: FontWeight.bold),),
          content: Text('Apakah yakin ingin keluar ?'),
          // actions: [yaButton, tidakButton],
          actions: <Widget>[
            FlatButton(
              child: Text('Ya'),
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.of(context).pop();
                AuthServices.signOut();
              },
            ),
            FlatButton(
              child: Text('Tidak'),
              color: Colors.red[700],
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
            ],
        );
      },
    );
  }
}
