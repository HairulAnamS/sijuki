import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilTabPage extends StatefulWidget {
  final FirebaseUser userLogin;
  const ProfilTabPage({
    Key key,
    @required this.userLogin,
  }) : super(key: key);
  @override
  _ProfilTabPageState createState() => _ProfilTabPageState();
}

class _ProfilTabPageState extends State<ProfilTabPage> {
  // TabController _tabController;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: AppBar(
              title: Text('Profil'),
              backgroundColor: Colors.white,
              bottom: TabBar(
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.red,
                tabs: [
                  new Tab(icon: new Icon(Icons.call)),
                  new Tab(
                    icon: new Icon(Icons.chat),
                  ),
                ],
                // controller: _tabController,
                // indicatorColor: Colors.white,
                // indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
          ),
          body: TabBarView(
            children: [
              new Text("This is call Tab View"),
              new Text("This is chat Tab View"),
            ],
            // controller: _tabController,
          ),
        ),
      ),
    );
  }
}
