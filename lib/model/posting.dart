import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sijuki/model/user.dart';

class Posting {
  int idposting;
  int iduser;
  String content;
  String urlGambar;
  String tglPosting;
  DateTime tglCreate;

  Posting(
      {this.idposting,
      this.iduser,
      this.content,
      this.urlGambar,
      this.tglPosting,
      this.tglCreate});

  factory Posting.fromJson(Map<String, dynamic> map) {
    return Posting(
        idposting: map["idposting"],
        iduser: map["iduser"],
        content: map["content"],
        urlGambar: map["urlGambar"],
        tglPosting: map["tglPosting"],
        tglCreate: map["tglCreate"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "idposting": idposting,
      "iduser": iduser,
      "content": content,
      "urlGambar": urlGambar,
      "tglPosting": tglPosting,
      "tglCreate": tglCreate
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
      'tglPosting': posting.tglPosting,
      'tglCreate': posting.tglCreate
    });
  }

  Future<void> getData() async {
    QuerySnapshot _myData = await dataCollection
        .orderBy('tglCreate', descending: true)
        .getDocuments();
    return _myData.documents;
  }

  // getData2() async {
  //   QuerySnapshot _myData = await dataCollection
  //       .orderBy('tglCreate', descending: true)
  //       .getDocuments();
  //   return _myData.documents;
  // }

  // getDataTest() async {
  //   var _user;
  //   UserDB userDB = new UserDB();
  //   // User user = new User();
  //   List<User> userList = [];

  //   QuerySnapshot docs = await dataCollection
  //       .orderBy('tglCreate', descending: true)
  //       .getDocuments();

  //   if (docs.documents.isNotEmpty) {
  //     for (int i = 0; i < docs.documents.length; i++) {
  //       await userDB
  //           .selectByID(docs.documents[i].data["iduser"])
  //           .then((QuerySnapshot docsUser) {
  //         _user = docsUser.documents[i].data;
  //         userList.add(User.fromJson(_user));
  //       });
  //     }
  //   }

  //   return userList;
  // }

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
