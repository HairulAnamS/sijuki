import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sijuki/widget/customclipper.dart';
import 'package:sijuki/screen/homepage.dart';
import 'package:sijuki/screen/homepage2.dart';
import 'package:sijuki/auth_services.dart';
import 'package:sijuki/bloc/tab_bloc.dart';
import 'package:sijuki/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sijuki/screen/profilpage.dart';
import 'package:sijuki/screen/test.dart';
import 'package:sijuki/screen/settingpage.dart';
import 'package:sijuki/screen/addpostingpage.dart';
import 'package:sijuki/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sijuki/model/posting.dart';

class MainPage extends StatefulWidget {
  final FirebaseUser userLogin;
  const MainPage({
    Key key,
    @required this.userLogin,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  User user = new User();
  UserDB userDB = new UserDB();
  var _user;
  List<User> userList = [];
  // bool isLoginOrRegister = true;

  // final List<Widget> _children = [
  //   HomePage(userLogin: null),
  //   HomePage(userLogin: null),
  //   TestPage(),
  //   ProfilPage(userLogin: null)
  // ];
  final List<String> _strTitle = ['Beranda', 'Search', 'Notifikasi', 'Profil'];

  PostingDB postingDB = new PostingDB();

  @override
  void initState() {
    super.initState();
    // user = new User();
    // userDB = new UserDB();
    // isLoginOrRegister = true;
    _getUser();
    //print('test: ' + _user['username']);

    // user = userDB.selectByEmail(widget.userLogin.email);
    // if (user.iduser != null) {
    //   print(user);
    // } else {
    //   print('durung metu nang init');
    // }
    // print('user init:' + user.email);
  }

  void _getUser() {
    userDB.selectByEmail(widget.userLogin.email).then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        _user = docs.documents[0].data;
        user = User.fromJson(_user);
      }
    });
  }

  void _goAddPosting(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddPostingPage(userLogin: user),
        ));

    if (result == true) {
      setState(() {
        // user = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.userLogin.email);
    TabBloc blocTab = BlocProvider.of<TabBloc>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<TabBloc, int>(
        builder: (context, idxTab) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: Icon(
              Icons.adb,
              color: Colors.red[700],
            ),
            actions: [
              Visibility(
                visible: (idxTab == tabProfil) ? true : false,
                child: IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.red[700],
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (context) => new SettingPage(
                                  userLogin: user,
                                )),
                      );
                    }),
              )
            ],
            title: Text(_strTitle[idxTab],
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.black,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ))),
          ),
          backgroundColor: Colors.white,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // print("step 1");
              // // user = await userDB.selectByIDNew(2);
              // userList = await postingDB.getDataTestUser();
              // print(userList.toString());
              // _goAddPosting(context);
              Navigator.of(context).push(
                new MaterialPageRoute<String>(
                    builder: (context) => new AddPostingPage(
                          userLogin: user,
                        )),
              );

              //Navigator.of(context).pop();
              // AuthServices.signOut();
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.red[700],
          ),
          bottomNavigationBar: ClipPath(
            clipper: BottomAppBarClipper(),
            child: BottomAppBar(
              elevation: 20,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                color: Colors.black12,
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //     border:
                //         Border(top: BorderSide(width: 1, color: Colors.grey))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: Icon(
                          Icons.home,
                          color: (idxTab == tabHome) ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          // isLoginOrRegister = false;
                          blocTab.add(TabEvent.to_home);
                          if (user.iduser != null) {
                            print(user.email);
                          } else {
                            print('durung');
                          }
                        }),
                    IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: Icon(
                          Icons.search_outlined,
                          color:
                              (idxTab == tabSerach) ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          // isLoginOrRegister = false;
                          blocTab.add(TabEvent.to_search);
                          //_getUser();
                          print(user.email);
                          // print(user.iduser.toString() + ' ' + user.username);
                          //print(widget.userLogin.email);
                          // user = userDB.selectByEmail(widget.userLogin.email);
                          // if (user.iduser != null) {
                          //   print('user page:' + user.username);
                          // }
                        }),
                    SizedBox(),
                    SizedBox(),
                    SizedBox(),
                    IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: Icon(
                          Icons.notifications,
                          color:
                              (idxTab == tabNotif) ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          // isLoginOrRegister = false;
                          blocTab.add(TabEvent.to_notif);
                        }),
                    IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: Icon(
                          Icons.person,
                          color:
                              (idxTab == tabProfil) ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          // isLoginOrRegister = false;
                          blocTab.add(TabEvent.to_profil);
                        }),
                  ],
                ),
              ),
            ),
          ),
          body: _getTab(idxTab, user),
        ),
      ),
    );
  }
}

Widget _getTab(int idx, User user) {
  if (idx == 1) {
    return HomePage2(userLogin: user);
  } else if (idx == 2) {
    return TestPage();
  } else if (idx == 3) {
    return ProfilPage(userLogin: user);
  } else {
    return HomePage(userLogin: user);
  }
}
