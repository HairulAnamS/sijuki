import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sijuki/model/user.dart';

class Posting {
  int idposting;
  int iduser;
  String content;
  String urlGambar;
  String urlFile;
  int jmlLike;
  int jmlComment;
  String tglPosting;
  DateTime tglCreate;
  DateTime tglUpdate;

  Posting(
      {this.idposting,
      this.iduser,
      this.content,
      this.urlGambar,
      this.urlFile,
      this.jmlLike,
      this.jmlComment,
      this.tglPosting,
      this.tglCreate,
      this.tglUpdate});

  factory Posting.fromJson(Map<String, dynamic> map) {
    return Posting(
        idposting: map["idposting"],
        iduser: map["iduser"],
        content: map["content"],
        urlGambar: map["urlGambar"],
        urlFile: map["urlFile"],
        jmlLike: map["jmlLike"],
        jmlComment: map["jmlComment"],
        tglPosting: map["tglPosting"],
        tglCreate: DateTime.fromMillisecondsSinceEpoch(
            map["tglCreate"].millisecondsSinceEpoch),
        tglUpdate: DateTime.fromMillisecondsSinceEpoch(
            map["tglUpdate"].millisecondsSinceEpoch));
  }

  Map<String, dynamic> toJson() {
    return {
      "idposting": idposting,
      "iduser": iduser,
      "content": content,
      "urlGambar": urlGambar,
      "urlFile": urlFile,
      "jmlLike": jmlLike,
      "jmlComment": jmlComment,
      "tglPosting": tglPosting,
      "tglCreate": tglCreate,
      "tglUpdate": tglUpdate
    };
  }

  @override
  String toString() {
    return "Posting{idposting: $idposting, iduser: $iduser, content: $content, urlGambar: $urlGambar, tglPosting: $tglPosting, tglCreate: $tglCreate}";
  }
}

List<Posting> objectFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Posting>.from(data.map((item) => Posting.fromJson(item)));
}

String objectToJson(Posting data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

class PostingDB {
  static CollectionReference dataCollection =
      Firestore.instance.collection('posting');

  Future<void> insert(Posting posting) async {
    await dataCollection.document(posting.idposting.toString()).setData({
      'idposting': posting.idposting,
      'iduser': posting.iduser,
      'content': posting.content,
      'urlGambar': posting.urlGambar,
      'urlFile': posting.urlFile,
      'jmlLike': posting.jmlLike,
      'jmlComment': posting.jmlComment,
      'tglPosting': posting.tglPosting,
      'tglCreate': posting.tglCreate,
      'tglUpdate': posting.tglUpdate
    });
  }

  Future<void> getData() async {
    QuerySnapshot _myData = await dataCollection
        .orderBy('tglCreate', descending: true)
        .getDocuments();
    return _myData.documents;
  }

  Future<List<Posting>> getDataBiasa() async {
    List<Posting> postingList = [];
    await dataCollection
        .orderBy('tglCreate', descending: true)
        .getDocuments()
        .then((docs) {
      if (docs.documents.length > 0) {
        postingList.clear();
        for (int i = 0; i < docs.documents.length; i++) {
          postingList.add(Posting.fromJson(docs.documents[i].data));
        }
      }
    });

    return postingList;
  }

  Future<List<User>> getDataUserPosting() async {
    List<User> userList = [];
    UserDB userDB = new UserDB();
    User user = new User();
    // var user1;

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

    print("step 2");
    //print(userList.toString());
    return userList;
  }

  Future<List<int>> getDataTest() async {
    List<int> idUserList = [];
    QuerySnapshot _myData = await dataCollection
        .orderBy('tglCreate', descending: true)
        .getDocuments();

    if (_myData.documents.length > 0) {
      idUserList.clear();
      for (int i = 0; i < _myData.documents.length; i++) {
        idUserList.add(_myData.documents[i].data["iduser"]);
      }
    }
    print("step 2");
    print(idUserList.toString());
    return idUserList;
  }

  Future<List<User>> getDataTestUser() async {
    List<User> userList = [];
    UserDB userDB = new UserDB();
    User user = new User();
    QuerySnapshot _myData = await dataCollection
        .orderBy('tglCreate', descending: true)
        .getDocuments();

    if (_myData.documents.length > 0) {
      userList.clear();
      for (int i = 0; i < _myData.documents.length; i++) {
        user = await userDB.selectByIDNew(_myData.documents[i].data["iduser"]);
        userList.add(user);
      }
    }
    print("step 2");
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
        .orderBy('idposting', descending: true)
        .limit(1)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((result) {
        print('idposting Posting: ${result.data["idposting"] + 1}');

        id = result.data["idposting"] + 1;
      });
    });
    return id;
  }
}
