import 'package:flutter/material.dart';
import 'package:sijuki/model/user.dart';
import 'package:sijuki/model/posting.dart';

class ViewPostingPage extends StatefulWidget {
  final User userLogin;
  final User userPosting;
  final Posting posting;
  const ViewPostingPage({
    Key key,
    @required this.userLogin,
    @required this.userPosting,
    @required this.posting,
  }) : super(key: key);

  @override
  _ViewPostingPageState createState() => _ViewPostingPageState();
}

class _ViewPostingPageState extends State<ViewPostingPage> {
  Posting posting;
  User userPosting;
  User userLogin;

  TextEditingController controllerComment = TextEditingController();

  @override
  void initState() {
    super.initState();
    posting = widget.posting;
    userPosting = widget.userPosting;
    userLogin = widget.userLogin;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // resizeToAvoidBottomPadding: true,
        // resizeToAvoidBottomInset: true,
        // resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.red[700],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "View Posting",
            style:
                TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),
          ),
        ),

        // bottomSheet: Container(
        //   padding: EdgeInsets.all(5),
        //   //height: 50,
        //   color: Colors.teal,
        //   child: TextField(
        //     controller: controllerComment,
        //     keyboardType: TextInputType.number,
        //     decoration: InputDecoration(
        //         border: InputBorder.none, hintText: 'Komentar disini...'),
        //   ),
        // ),

        bottomSheet: Container(
          color: Colors.grey[300],
          padding: EdgeInsets.all(10),
          // margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: Colors.redAccent,
                backgroundImage:
                    (userPosting.urlPhoto == "" || userPosting.urlPhoto == null)
                        ? AssetImage("img/noprofile.png")
                        : NetworkImage(userPosting.urlPhoto),
              ),
              Container(
                // color: Colors.redAccent,
                // height: 40,
                width: 250,
                child: TextField(
                  onChanged: (value) {},
                  controller: controllerComment,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Komentar disini...'),
                ),
              ),
              IconButton(icon: Icon(Icons.send), onPressed: () {})
            ],
          ),
        ),

        body: ListView(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.redAccent,
                      backgroundImage: (userPosting.urlPhoto == "" ||
                              userPosting.urlPhoto == null)
                          ? AssetImage("img/noprofile.png")
                          : NetworkImage(userPosting.urlPhoto),
                    ),
                    title: (userPosting.username != null)
                        ? Text(userPosting.username)
                        : Text(''),
                    subtitle: Text(
                      posting.tglPosting,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(posting.content))),
                  (posting.urlGambar == "" || posting.urlGambar == null)
                      ? Container()
                      : Image(
                          height: 200,
                          width: double.infinity,
                          image: NetworkImage(posting.urlGambar),
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
                          Icon(Icons.comment, size: 20),
                          (posting.jmlComment > 0)
                              ? Text(
                                  posting.jmlComment.toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                )
                              : Text(""),
                          SizedBox(width: 20),
                          Icon(Icons.favorite_border, size: 20),
                          (posting.jmlLike > 0)
                              ? Text(
                                  posting.jmlLike.toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                )
                              : Text(""),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
