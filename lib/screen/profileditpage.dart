import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sijuki/model/user.dart';
import 'package:path/path.dart' as _path;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sijuki/bloc/loading_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sijuki/widget/colorloader.dart';
import 'package:sijuki/widget/customalert.dart';

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
  TextEditingController controlNohp = TextEditingController();

  FocusNode myFocusNode = new FocusNode();

  File _image;
  String _nameImage = '';
  String _urlImage = '';
  String _message = '';

  bool _result;
  bool _validateUsername = true;
  bool _validateAlamat = true;
  // bool _validatePekerjaan = true;
  bool _validateNohp = true;

  User user = new User();
  UserDB userDB = new UserDB();
  var _user;

  @override
  void initState() {
    super.initState();

    user = widget.userLogin;

    controlUsername.text = user.username;
    controlNohp.text = user.nohp;
    controlPekerjaan.text = user.pekerjaan;
    controlAlamat.text = user.alamat;

    if (user.urlPhoto != "") _urlImage = user.urlPhoto;

    // _getUser();

    
  }

  // void _getUser() {
  //   userDB.selectByID(widget.userLogin.iduser).then((QuerySnapshot docs) {
  //     if (docs.documents.isNotEmpty) {
  //       _user = docs.documents[0].data;
  //       user = User.fromJson(_user);
  //     }
  //   });
  // }

  Future getImage() async {
    File image;
    image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = image;
        _nameImage = _path.basename(image.path);
        print(_nameImage);
      }
    });

    if (_image != null) {
      _uploadImage();
    }
  }

  Future<String> _uploadImage() async {
    StorageReference ref = FirebaseStorage.instance.ref().child(_nameImage);
    StorageUploadTask uploadtTask = ref.putFile(_image);

    var urlDownl = await (await uploadtTask.onComplete).ref.getDownloadURL();
    setState(() {
      _urlImage = urlDownl.toString();
    });

    print('Url Gambar : $_urlImage');
    return _urlImage;
  }

  bool _checkValidate() {
    _validateUsername = true;
    _validateNohp = true;
    _result = true;

    setState(() {
      if (controlUsername.text.trim() == "") {
        _validateUsername = false;
        _result = false;
      }
      if (controlNohp.text.trim() == "") {
        _validateNohp = false;
        _result = false;
      }
    });
    return _result;
  }

  _loadData() {
    user.username = controlUsername.text;
    user.nohp = controlNohp.text;
    user.pekerjaan = controlPekerjaan.text;
    user.alamat = controlAlamat.text;
    user.urlPhoto = _urlImage;
  }

  Future<void> _updateUser(BuildContext context, LoadingBloc bloc) async {
    try {
      if (_checkValidate()) {
        // bloc.add(LoadingEvent.to_show);
        _loadData();
        userDB.update(user);
        // bloc.add(LoadingEvent.to_hide);
      } else {
        print(_message);
        Alertku.showAlertCustom(context, _message);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    LoadingBloc blocLoading = BlocProvider.of<LoadingBloc>(context);

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
                          // backgroundImage: AssetImage("img/noprofile.png"),
                          backgroundImage: (_urlImage == "")
                              ? AssetImage("img/noprofile.png")
                              : NetworkImage(_urlImage),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 100,
                        child: GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.red[700],
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              )),
                        ),
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
                          errorText:
                              (_validateAlamat) ? null : 'No Hp harus diisi'),
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
                          onPressed: () {
                            _updateUser(context, blocLoading);
                            Navigator.of(context).pop();
                          },
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
