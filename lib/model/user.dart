import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  int iduser;
  String username;
  String email;
  String password;
  String nohp;
  String pekerjaan;
  String alamat;
  DateTime tglCreate;

  User(
      {this.iduser,
      this.username,
      this.email,
      this.password,
      this.nohp,
      this.pekerjaan,
      this.alamat,
      this.tglCreate});

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
        iduser: map["iduser"],
        username: map["username"],
        email: map["email"],
        password: map["password"],
        nohp: map["nohp"],
        pekerjaan: map["pekerjaan"],
        alamat: map["alamat"],
        tglCreate: DateTime.fromMillisecondsSinceEpoch(
            map["tglCreate"].millisecondsSinceEpoch));
  }

  Map<String, dynamic> toJson() {
    return {
      "iduser": iduser,
      "username": username,
      "email": email,
      "password": password,
      "nohp": nohp,
      "pekerjaan": pekerjaan,
      "alamat": alamat,
      "tglCreate": tglCreate
    };
  }

  @override
  String toString() {
    return "User{iduser: $iduser, username: $username, email: $email, password: $password}";
  }
}

List<User> objectFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<User>.from(data.map((item) => User.fromJson(item)));
}

String objectToJson(User data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

class UserDB {
  User user = new User();
  static CollectionReference dataCollection =
      Firestore.instance.collection('user');

  Future<void> insert(User user) async {
    await dataCollection.document(user.iduser.toString()).setData({
      'iduser': user.iduser,
      'username': user.username,
      'email': user.email,
      'password': user.password,
      'nohp': user.nohp,
      'pekerjaan': user.pekerjaan,
      'alamat': user.alamat,
      'tglCreate': user.tglCreate
    });
  }

  selectByID(int id) {
    return dataCollection.where('iduser', isEqualTo: id).getDocuments();
  }

  selectByEmail(String email) {
    return dataCollection.where('email', isEqualTo: email).getDocuments();
    // await dataCollection
    //     .where('email', isEqualTo: email)
    //user = User.fromJson(query.documents.forEach((element) { }));

    // await dataCollection
    //     .where('email', isEqualTo: email)
    //     .snapshots()
    //     .listen((snapshot) {
    //   snapshot.documents.forEach((f) {
    //     print(f.data);
    //     user = User.fromJson(f.data);
    //     print(user);
    //   });
    // });

    // print('lewat selectByEmail');
    // print(user.username);
    // return user;
  }

  Future<int> getMaxID() async {
    int id = 0;
    await dataCollection
        .orderBy('iduser', descending: true)
        .limit(1)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((result) {
        print('iduser user: ${result.data["iduser"] + 1}');

        id = result.data["iduser"] + 1;
      });
    });
    return id;
  }
}
