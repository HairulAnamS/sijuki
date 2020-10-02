import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sijuki/model/user.dart';

class Notif {
  int idnotif;
  int idposting;
  int iduserPosting;
  int iduserNotif;
  bool isRead;
  String jnsNotif;
  String pesanNotif;
  DateTime tglNotif;

  Notif(
      {this.idnotif,
      this.idposting,
      this.iduserPosting,
      this.iduserNotif,
      this.isRead,
      this.jnsNotif,
      this.pesanNotif,
      this.tglNotif});

  factory Notif.fromJson(Map<String, dynamic> map) {
    return Notif(
        idnotif: map["idnotif"],
        idposting: map["idposting"],
        iduserPosting: map["iduserPosting"],
        iduserNotif: map["iduserNotif"],
        isRead: map["isRead"],
        jnsNotif: map["jnsNotif"],
        pesanNotif: map["pesanNotif"],
        tglNotif: DateTime.fromMillisecondsSinceEpoch(
            map["tglNotif"].millisecondsSinceEpoch));
  }

  Map<String, dynamic> toJson() {
    return {
      "idnotif": idnotif,
      "idposting": idposting,
      "iduserPosting": iduserPosting,
      "iduserNotif": iduserNotif,
      "isRead": isRead,
      "jnsNotif": jnsNotif,
      "pesanNotif": pesanNotif,
      "tglNotif": tglNotif
    };
  }

  @override
  String toString() {
    return "Notif{idnotif: $idnotif, iduserPosting: $iduserPosting, pesanNotif: $pesanNotif, tglNotif: $tglNotif}";
  }
}

List<Notif> objectFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Notif>.from(data.map((item) => Notif.fromJson(item)));
}

String objectToJson(Notif data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

class NotifDB {
  static CollectionReference dataCollection =
      Firestore.instance.collection('notif');

  Future<void> insert(Notif notif) async {
    await dataCollection.document(notif.idnotif.toString()).setData({
      'idnotif': notif.idnotif,
      'idposting': notif.idposting,
      'iduserPosting': notif.iduserPosting,
      'iduserNotif': notif.iduserNotif,
      'isRead': notif.isRead,
      'jnsNotif': notif.jnsNotif,
      'pesanNotif': notif.pesanNotif,
      'tglNotif': notif.tglNotif
    });
  }

  Future<void> getData() async {
    QuerySnapshot _myData = await dataCollection
        .orderBy('tglCreate', descending: true)
        .getDocuments();
    return _myData.documents;
  }

  Future<List<Notif>> getNotifPostingan(int iduser) async {
    List<Notif> notifList = [];
    await dataCollection
        .where('iduserPosting', isEqualTo: iduser)
        .orderBy('tglNotif', descending: true)
        .getDocuments()
        .then((docs) {
      if (docs.documents.length > 0) {
        notifList.clear();
        for (int i = 0; i < docs.documents.length; i++) {
          notifList.add(Notif.fromJson(docs.documents[i].data));
        }
      }
    });

    return notifList;
  }

  Future<List<User>> getUserNotifPostingan(int iduser) async {
    List<User> userList = [];
    UserDB userDB = new UserDB();
    User user = new User();

    await dataCollection
        .where('iduserPosting', isEqualTo: iduser)
        .orderBy('tglNotif', descending: true)
        .getDocuments()
        .then((docs) async {
      if (docs.documents.length > 0) {
        userList.clear();
        for (int i = 0; i < docs.documents.length; i++) {
          user = await userDB.selectByIDNew(docs.documents[i].data["iduserNotif"]);
          userList.add(user);
        }
      }
    });

    // print("step 2");
    //print(userList.toString());
    return userList;
  }

  Future<void> getDataPribadi(int iduserPosting) async {
    QuerySnapshot _myData = await dataCollection
        .where('iduserPosting', isEqualTo: iduserPosting)
        .orderBy('tglCreate', descending: true)
        .getDocuments();
    return _myData.documents;
  }

  Future<int> getMaxID() async {
    int id = 1;
    await dataCollection
        .orderBy('idnotif', descending: true)
        .limit(1)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((result) {
        print('idnotif Notif: ${result.data["idnotif"] + 1}');

        id = result.data["idnotif"] + 1;
      });
    });
    return id;
  }
}
