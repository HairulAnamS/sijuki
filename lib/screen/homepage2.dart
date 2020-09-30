import 'package:flutter/material.dart';
import 'package:sijuki/model/user.dart';
import 'package:sijuki/model/posting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sijuki/screen/testing.dart';
import 'package:sijuki/screen/viewpdfpage.dart';
import 'package:sijuki/screen/viewpostingpage.dart';

class HomePage2 extends StatefulWidget {
  final User userLogin;
  const HomePage2({
    Key key,
    @required this.userLogin,
  }) : super(key: key);

  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  User userPosting = new User();
  UserDB userDB = new UserDB();
  Posting posting = new Posting();
  PostingDB postingDB = new PostingDB();

  List<Posting> postingList = [];
  List<User> userPostingList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _ambilData();
  }

  void _ambilData() async {
    print("step 1 home");
    userPostingList = await postingDB.getDataUserPosting();
    print("step 2 home");
    postingList = await postingDB.getDataBiasa();
    print("step 3 home");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: postingList.length,
            itemBuilder: (_, index) {
              final postingans = postingList[index];
              // final userPos = postingDB.getDataTestUser();
              // userList = postingDB.getDataTest();
              //_getUser(dataPosting.data[index].data["iduser"]);
              return Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 5.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.redAccent,
                        backgroundImage:
                            (userPostingList[index].urlPhoto == "" ||
                                    userPostingList[index].urlPhoto == null)
                                ? AssetImage("img/noprofile.png")
                                : NetworkImage(userPostingList[index].urlPhoto),
                      ),
                      title: (userPostingList[index].username != null)
                          ? Text(userPostingList[index].username)
                          : Text(''),
                      // title: Text(postingans.data["iduser"].toString()),
                      subtitle: Text(
                        postingans.tglPosting,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(postingans.content))),
                    (postingans.urlGambar == "" || postingans.urlGambar == null)
                        ? Container()
                        : Image(
                            height: 200,
                            width: double.infinity,
                            image: NetworkImage(postingans.urlGambar),
                            fit: BoxFit.fitHeight,
                          ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 30,
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: Icon(Icons.comment, size: 20),
                              onTap: () {
                                Navigator.of(context).push(
                                  new MaterialPageRoute(
                                      builder: (context) => new ViewPostingPage(
                                            posting: postingans,
                                            userLogin: widget.userLogin,
                                            userPosting: userPostingList[index],
                                          )),
                                );
                              },
                            ),
                            (postingans.jmlComment > 0)
                                ? Text(
                                    postingans.jmlComment.toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  )
                                : Text(""),
                            SizedBox(width: 20),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            new TestingPage()),
                                  );
                                },
                                child: Icon(Icons.favorite_border, size: 20)),
                            (postingans.jmlLike > 0)
                                ? Text(
                                    postingans.jmlLike.toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  )
                                : Text(""),
                            Spacer(),
                            (postingans.urlFile != "")
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        new MaterialPageRoute<String>(
                                            builder: (context) =>
                                                new ViewPdfPage(
                                                  posting: postingans,
                                                  namaUserPosting:
                                                      userPostingList[index]
                                                          .username,
                                                )),
                                      );
                                    },
                                    child: Icon(Icons.picture_as_pdf_outlined))
                                : Text("")
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
  }
}
