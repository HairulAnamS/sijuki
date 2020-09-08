// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sijuki/screen/profilTabpage.dart';
import 'package:sijuki/screen/tabPosting.dart';
import 'package:sijuki/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sijuki/model/posting.dart';

class ProfilPage extends StatefulWidget {
  final User userLogin;
  const ProfilPage({
    Key key,
    @required this.userLogin,
  }) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final List<Widget> _children = [
    TabPosting(
      userLogin: null,
      colorku: Colors.blueAccent,
    ),
    TabPosting(userLogin: null, colorku: Colors.redAccent),
    // HomePage(colorku: Colors.greenAccent),
    // ProfilPage(userLogin: null)
  ];

  final List<String> _str = [
    'aku suka kamu, tapi boong, iyyak..',
    'aku kamu dia bapakmu adikmu ibumu dan juga keluargamu',
    'Jika sebuah penampung hanya memiliki satu turunan tingkat atas, Anda dapat menentukan properti penyelarasan untuk anak tersebut dan memberikan nilai yang tersedia. itu akan mengisi semua ruang di wadah.'
  ];

  int _idx = 0;
  User user = new User();
  UserDB userDB = new UserDB();
  Posting posting = new Posting();
  PostingDB postingDB = new PostingDB();
  // var _user;

  @override
  void initState() {
    super.initState();
    user = widget.userLogin;
    // _getUser();
  }

  // void _getUser() {
  //   userDB.selectByEmail(widget.userLogin.email).then((QuerySnapshot docs) {
  //     if (docs.documents.isNotEmpty) {
  //       _user = docs.documents[0].data;
  //       user = User.fromJson(_user);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 10),
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.redAccent,
                    backgroundImage: AssetImage("img/heru_logo.jpg"),
                    // NetworkImage(
                    //     'https://www.woolha.com/media/2020/03/eevee.png'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  (user.iduser != null)
                      ? Text(
                          user.username,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Text('')
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.email),
                      SizedBox(
                        width: 10,
                      ),
                      (user.iduser != null)
                          ? Text(user.email)
                          : Text('data belum dapat')
                    ],
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(
                        width: 10,
                      ),
                      (user.iduser != null)
                          ? Text('Surabaya, Indonesia')
                          : Text('Indonesia')
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          height: 30,
          color: Colors.grey[200],
          child: FlatButton.icon(
              onPressed: () {},
              icon: Icon(Icons.edit),
              label: Text('Edit Profil')),
        ),
        Container(
          height: 2,
          color: Colors.grey[200],
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          height: 50,
          margin: EdgeInsets.only(top: 10),
          // padding: EdgeInsets.only(bottom: 30),
          // color: Colors.redAccent,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: Text('Postingan'),
                    onTap: () {
                      setState(() {
                        _idx = 0;
                      });
                    },
                  ),
                  GestureDetector(
                    child: Text('Komentar'),
                    onTap: () {
                      setState(() {
                        _idx = 1;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 5,
                    color: Colors.blueAccent,
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                  Container(
                    height: 5,
                    color: Colors.redAccent,
                    width: MediaQuery.of(context).size.width * 0.5,
                  )
                ],
              )
            ],
          ),
        ),
        FutureBuilder(
            future: postingDB.getDataPribadi(user.iduser),
            builder: (_, dataPosting) {
              if (dataPosting.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: dataPosting.data.length,
                    itemBuilder: (_, index) {
                      final postingans = dataPosting.data[index];
                      return Container(
                          // height: MediaQuery.of(context).size.height * 0.6,
                          //margin: EdgeInsets.all(5),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.redAccent,
                                  backgroundImage:
                                      AssetImage("img/heru_logo.jpg"),
                                  // NetworkImage(
                                  //     'https://www.woolha.com/media/2020/03/eevee.png'),
                                ),
                                title: Text(user.username),
                                subtitle: Text(
                                  postingans.data["tglPosting"],
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(postingans.data["content"])),
                              Image(
                                height: 200,
                                width: double.infinity,
                                image: NetworkImage(postingans.data["urlGambar"]),
                                fit: BoxFit.contain,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 30,
                                  padding: EdgeInsets.only(left: 15),
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.comment, size: 20),
                                      Text(
                                        '10',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                      SizedBox(width: 20),
                                      Icon(Icons.share, size: 20),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 2,
                                color: Colors.grey[200],
                              ),
                            ],
                          ));
                    });
              } else if (dataPosting.hasError) {
                return Text('Data Error');
              } else {
                return Center(child: CircularProgressIndicator());
              }
            })
      ],
    );
  }
}
