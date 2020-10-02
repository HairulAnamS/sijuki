import 'package:flutter/material.dart';
import 'package:sijuki/constant.dart';
import 'package:sijuki/model/notif.dart';
import 'package:sijuki/model/user.dart';
import 'package:sijuki/model/posting.dart';
import 'package:sijuki/model/comment.dart';
import 'package:sijuki/widget/customalert.dart';
import 'package:intl/intl.dart';

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
  PostingDB postingDB;
  User userPosting;
  User userLogin;
  Notif notif;
  NotifDB notifDB;

  Comment comment;
  CommentDB commentDB;
  int fIdComment;
  int fIdNotif;

  bool _result;
  bool validateComment = true;
  String _message = "";

  List<Comment> commentList = [];
  List<User> userCommentList = [];
  bool isLoading = true;

  TextEditingController controllerComment = TextEditingController();

  @override
  void initState() {
    super.initState();
    posting = widget.posting;
    userPosting = widget.userPosting;
    userLogin = widget.userLogin;

    comment = new Comment();
    commentDB = new CommentDB();
    postingDB = new PostingDB();
    notif = new Notif();
    notifDB = new NotifDB();

    getID();
    ambilDataComment();
  }

  @override
  void dispose() {
    controllerComment.dispose();
    super.dispose();
  }

  void getID() async {
    fIdComment = await commentDB.getMaxID();
    fIdNotif = await notifDB.getMaxID();
    // fIdComment = 1;
  }

  void ambilDataComment() async {
    print("start ambil user comment");
    userCommentList =
        await commentDB.getUserCommentPostingan(posting.idposting);
    print("start ambil data comment");
    commentList = await commentDB.getCommentPostingan(posting.idposting);
    print("step 3 home");
    setState(() {
      isLoading = false;
    });
  }

  void refreshPosting() async{
    posting = await postingDB.selectByID(widget.posting.idposting);
  }

  _loadData() {
    comment.idcomment = fIdComment;
    comment.iduser = userLogin.iduser;
    comment.idposting = posting.idposting;
    comment.komentar = controllerComment.text;
    comment.tglComment = DateTime.now();

    notif.idnotif = fIdNotif;
    notif.idposting = posting.idposting;
    notif.iduserPosting = userPosting.iduser;
    notif.iduserNotif = userLogin.iduser;
    notif.isRead = false;
    notif.jnsNotif = notif_comment;
    notif.pesanNotif = 'mengomentari postinganmu';
    notif.tglNotif = DateTime.now();
  }

  bool _checkValidate() {
    validateComment = true;
    _result = true;

    setState(() {
      if (controllerComment.text.trim() == "") {
        validateComment = false;
        _result = false;
      }
      // print('idComment validate: $fIdComment');
    });
    return _result;
  }

  Future<void> addComment(BuildContext context) async {
    try {
      if (_checkValidate()) {
        _loadData();
        commentDB.insert(comment);
        postingDB.updateJmlComment(posting);
        notifDB.insert(notif);
      } else {
        _message = "Comment kosong";
        print(_message);
        Alertku.showAlertCustom(context, _message);
      }

      getID();
      ambilDataComment();
      refreshPosting();
      setState(() {
        
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // backgroundColor: Colors.white,
        // resizeToAvoidBottomPadding: true,
        // resizeToAvoidBottomInset: true,
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

        bottomSheet: Container(
          color: Colors.grey[300],
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: Colors.redAccent,
                backgroundImage:
                    (userLogin.urlPhoto == "" || userLogin.urlPhoto == null)
                        ? AssetImage("img/noprofile.png")
                        : NetworkImage(userLogin.urlPhoto),
              ),
              Container(
                // color: Colors.redAccent,
                // height: 40,
                width: 250,
                child: TextField(
                  onChanged: (value) {
                    if (fIdComment == null || fIdNotif == null) {
                      getID();
                      print('idcomment: $fIdComment, idNotif: $fIdNotif');
                    } else {
                      print('idcomment wes: $fIdComment, idNotif: $fIdNotif');
                    }
                  },
                  controller: controllerComment,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Komentar disini...'),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    addComment(context);
                    controllerComment.text = '';
                  })
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
                        ? Text(
                            userPosting.username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
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
            ),
            Container(height: 1, color: Colors.grey[300]),
            (isLoading)
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: commentList.length,
                    itemBuilder: (_, index) {
                      final comments = commentList[index];
                      final userComments = userCommentList[index];

                      return Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              backgroundImage: (userComments.urlPhoto == "" ||
                                      userComments.urlPhoto == null)
                                  ? AssetImage("img/noprofile.png")
                                  : NetworkImage(userComments.urlPhoto),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Container(
                                  width: 300,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      // border: Border.all(
                                      //     width: 1.5, color: Colors.red),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          bottomRight: Radius.circular(15))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Padding(
                                      //   padding: const EdgeInsets.all(10.0),
                                      //   child: Text(userComments.username + '     ' + DateFormat('[kk:mm]').format(comments.tglComment)),
                                      // ),
                                      Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                userComments.username,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Spacer(),
                                              Text(
                                                DateFormat('dd MMM kk:mm').format(
                                                    comments.tglComment),
                                                style: TextStyle(fontSize: 11),
                                              )
                                            ],
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(comments.komentar),
                                      )
                                    ],
                                  )),
                            )
                          ],
                        ),
                      );
                    })
          ],
        ),
      ),
    );
  }
}
