import 'package:flutter/material.dart';
import 'package:sijuki/model/user.dart';
import 'package:sijuki/model/posting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final User userLogin;
  const HomePage({
    Key key,
    @required this.userLogin,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future _dataPosting;
  User user = new User();
  UserDB userDB = new UserDB();
  Posting posting = new Posting();
  PostingDB postingDB = new PostingDB();

  var _user;

  @override
  void initState() {
    super.initState();
    _dataPosting = postingDB.getData();
    // _dataPosting = postingDB.getData();
  }

  void _getUser(int iduser) {
    userDB.selectByID(iduser).then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        _user = docs.documents[0].data;
        user = User.fromJson(_user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: postingDB.getData(),
        builder: (_, dataPosting) {
          if (dataPosting.hasData) {
            return ListView.builder(
                itemCount: dataPosting.data.length,
                itemBuilder: (_, index) {
                  final postingans = dataPosting.data[index];
                  _getUser(dataPosting.data[index].data["iduser"]);
                  return Container(
                    //height: 300,
                    color: Colors.white,
                    margin: EdgeInsets.only(top: 5.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.redAccent,
                            backgroundImage: AssetImage("img/heru_logo.jpg"),
                            // NetworkImage(
                            //     'https://www.woolha.com/media/2020/03/eevee.png'),
                          ),
                          title: (user.username != null) ? Text(user.username): Text(''),
                          subtitle: Text(
                            postingans.data["tglPosting"],
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(postingans.data["content"]))),
                        Image(
                          height: 200,
                          width: double.infinity,
                          image: NetworkImage(postingans.data["urlGambar"]),
                          fit: BoxFit.fitHeight,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 30,
                            padding: EdgeInsets.only(left: 15),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  );
                });
          } else if (dataPosting.hasError) {
            return Text('Data error');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
