import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sijuki/model/user.dart';
import 'package:sijuki/model/notif.dart';

class NotifPage extends StatefulWidget {
  final User userLogin;
  const NotifPage({
    Key key,
    @required this.userLogin,
  }) : super(key: key);

  @override
  _NotifPageState createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  bool isLoading;
  Notif notif;
  NotifDB notifDB;
  User user;
  UserDB userDB;

  List<User> userNotifList = [];
  List<Notif> notifList = [];

  @override
  void initState() {
    isLoading = true;
    user = widget.userLogin;
    notif = new Notif();
    notifDB = new NotifDB();
    userDB = new UserDB();
    ambilData();
    super.initState();
  }

  void ambilData() async {
    print('start ambil user notif');
    userNotifList = await notifDB.getUserNotifPostingan(user.iduser);
    print('start ambil notif');
    notifList = await notifDB.getNotifPostingan(user.iduser);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: notifList.length,
            itemBuilder: (_, index) {
              final userNotifs = userNotifList[index];
              final notifs = notifList[index];

              return Container(
                  // color: Colors.grey[200],
                  // margin: EdgeInsets.all(5),
                  // padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.redAccent,
                          backgroundImage: (userNotifs.urlPhoto == "" ||
                                  userNotifs.urlPhoto == null)
                              ? AssetImage("img/noprofile.png")
                              : NetworkImage(userNotifs.urlPhoto),
                        ),
                        title: Text(
                          userNotifs.username + ' ' + notifs.pesanNotif,
                          style: TextStyle(fontSize: 13),
                        ),
                        subtitle: Text(
                          DateFormat('dd MMM kk:mm').format(notifs.tglNotif),
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Colors.grey[300],
                      )
                    ],
                  ));
            });
  }
}
