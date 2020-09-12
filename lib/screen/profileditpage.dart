import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sijuki/model/user.dart';

class ProfilEditPage extends StatefulWidget {
  final User userLogin;
  const ProfilEditPage({
    Key key,
    @required this.userLogin,
  }) : super(key: key);

  @override
  _ProfilEditPageState createState() => _ProfilEditPageState();
}

class _ProfilEditPageState extends State<ProfilEditPage> {
  TextEditingController controlUsername = TextEditingController();
  TextEditingController controlAlamat = TextEditingController();
  TextEditingController controlPekerjaan = TextEditingController();
  TextEditingController controlNohp= TextEditingController();

  FocusNode myFocusNode = new FocusNode();

  bool _result;
  bool _validateUsername = true;
  bool _validateAlamat = true;
  bool _validatePekerjaan = true;
  bool _validateNohp = true;

  User user = new User();
  UserDB userDB = new UserDB();

  @override
  void initState() {
    super.initState();
    user = widget.userLogin;

    controlUsername.text = user.username;
    controlNohp.text = user.nohp;
    controlPekerjaan.text = user.pekerjaan;
    controlAlamat.text = user.alamat;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.red[700],
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Edit Profil',
            style:
                TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: ListView(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage("img/heru_logo.jpg"),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 100,
                        child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.red[700],
                            child: Icon(Icons.edit, color: Colors.white,)),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: TextField(
                      onChanged: (value) {},
                      controller: controlUsername,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          //filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.red[700]),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.red[700]),
                          ),

                          //hintText: "Username",
                          labelText: "Username",
                          errorText: (_validateUsername)
                              ? null
                              : 'Username harus diisi'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextField(
                      // focusNode: myFocusNode,
                      onChanged: (value) {},
                      controller: controlNohp,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.red[700]),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.red[700]),
                          ),

                          //hintText: "Pekerjaan",
                          labelText: "No Hp",
                          // labelStyle: TextStyle(color: myFocusNode.hasFocus ? Colors.red[700] : Colors.grey),
                          errorText: (_validateAlamat)
                              ? null
                              : 'No Hp harus diisi'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextField(
                      // focusNode: myFocusNode,
                      onChanged: (value) {},
                      controller: controlPekerjaan,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.red[700]),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.red[700]),
                          ),

                          //hintText: "Pekerjaan",
                          labelText: "Pekerjaan",
                          // labelStyle: TextStyle(color: myFocusNode.hasFocus ? Colors.red[700] : Colors.grey),
                          errorText: (_validateAlamat)
                              ? null
                              : 'Pekerjaan harus diisi'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextField(
                      onChanged: (value) {},
                      controller: controlAlamat,
                      keyboardType: TextInputType.text,
                      maxLines: 3,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.red[700]),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.red[700]),
                          ),
                          //hintText: "Alamat",
                          labelText: "Alamat",
                          errorText:
                              (_validateAlamat) ? null : 'Alamat harus diisi'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Container(
                      width: double.infinity - 20,
                      height: 40,
                      child: RaisedButton.icon(
                          onPressed: () {},
                          color: Colors.red[700],
                          icon: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          shape: StadiumBorder(),
                          label: Text(
                            "S A V E",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
