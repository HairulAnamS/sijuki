import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sijuki/model/user.dart';

class Comment {
  int idcomment;
  int idposting;
  int iduser;
  String komentar;
  DateTime tglComment;

  Comment(
      {this.idcomment,
      this.idposting,
      this.iduser,
      this.komentar,
      this.tglComment});

  factory Comment.fromJson(Map<String, dynamic> map) {
    return Comment(
        idcomment: map["idcomment"],
        idposting: map["idposting"],
        iduser: map["iduser"],
        komentar: map["komentar"],
        tglComment: DateTime.fromMillisecondsSinceEpoch(
            map["tglComment"].millisecondsSinceEpoch));
  }

  Map<String, dynamic> toJson() {
    return {
      "idcomment": idcomment,
      "idposting": idposting,
      "iduser": iduser,
      "komentar": komentar,
      "tglComment": tglComment
    };
  }

  @override
  String toString() {
    return "Comment{idcomment: $idcomment, iduser: $iduser, komentar: $komentar, tglComment: $tglComment}";
  }
}

List<Comment> objectFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Comment>.from(data.map((item) => Comment.fromJson(item)));
}

String objectToJson(Comment data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

class CommentDB {
  static CollectionReference dataCollection =
      Firestore.instance.collection('comment');

  Future<void> insert(Comment comment) async {
    await dataCollection.document(comment.idcomment.toString()).setData({
      'idcomment': comment.idcomment,
      'idposting': comment.idposting,
      'iduser': comment.iduser,
      'komentar': comment.komentar,
      'tglComment': comment.tglComment
    });
  }

  Future<void> getData() async {
    QuerySnapshot _myData = await dataCollection
        .orderBy('tglCreate', descending: true)
        .getDocuments();
    return _myData.documents;
  }

  Future<List<Comment>> getDataBiasa() async {
    List<Comment> commentList = [];
    await dataCollection
        .orderBy('tglCreate', descending: true)
        .getDocuments()
        .then((docs) {
      if (docs.documents.length > 0) {
        commentList.clear();
        for (int i = 0; i < docs.documents.length; i++) {
          commentList.add(Comment.fromJson(docs.documents[i].data));
        }
      }
    });

    return commentList;
  }

  Future<List<User>> getDataUserComment() async {
    List<User> userList = [];
    UserDB userDB = new UserDB();
    User user = new User();

    await dataCollection
        .orderBy('tglCreate', descending: true)
        .getDocuments()
        .then((docs) async {
      if (docs.documents.length > 0) {
        userList.clear();
        for (int i = 0; i < docs.documents.length; i++) {
          user = await userDB.selectByIDNew(docs.documents[i].data["iduser"]);
          userList.add(user);
        }
      }
    });

    // print("step 2");
    //print(userList.toString());
    return userList;
  }

  Future<void> getDataPribadi(int iduser) async {
    QuerySnapshot _myData = await dataCollection
        .where('iduser', isEqualTo: iduser)
        .orderBy('tglCreate', descending: true)
        .getDocuments();
    return _myData.documents;
  }

  Future<int> getMaxID() async {
    int id = 1;
    await dataCollection
        .orderBy('idcomment', descending: true)
        .limit(1)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((result) {
        print('idcomment Comment: ${result.data["idcomment"] + 1}');

        id = result.data["idcomment"] + 1;
      });
    });
    return id;
  }
}
