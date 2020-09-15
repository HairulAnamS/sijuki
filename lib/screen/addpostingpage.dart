import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as _path;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:sijuki/model/posting.dart';
import 'package:date_format/date_format.dart';
import 'package:sijuki/widget/customalert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sijuki/model/user.dart';

class AddPostingPage extends StatefulWidget {
  final User userLogin;
  const AddPostingPage({
    Key key,
    @required this.userLogin,
  }) : super(key: key);

  @override
  _AddPostingPageState createState() => _AddPostingPageState();
}

class _AddPostingPageState extends State<AddPostingPage> {
  TextEditingController controllerPosting = TextEditingController();

  File _image;
  // List<File> _listImage;
  // String _imagePath = '';
  String _nameImage = '';
  String _urlImage = '';

  int fidposting;
  Posting posting;
  PostingDB postingDB;

  bool _result;
  bool _validateContent = true;
  String _message = "";

  User user = new User();
  UserDB userDB = new UserDB();

  @override
  void initState() {
    super.initState();
    user = widget.userLogin;
    posting = new Posting();
    postingDB = new PostingDB();
    getPostingID();
    print('idposting init: $fidposting');
    print('iduser init: ' + user.username);
  }

  void getPostingID() async {
    fidposting = await postingDB.getMaxID();
  }

  _loadData() {
    posting.idposting = fidposting;
    posting.iduser = widget.userLogin.iduser;
    posting.content = controllerPosting.text;
    posting.urlGambar = _urlImage;
    posting.tglPosting =
        formatDate(DateTime.now(), [dd, ' ', MM, ' ', yyyy, ' ', H, ':', nn]);
    posting.tglCreate = DateTime.now();
  }

  bool _checkValidate() {
    _validateContent = true;
    _result = true;

    setState(() {
      if (controllerPosting.text.trim() == "") {
        _validateContent = false;
        _result = false;
      }
      print('idposting validate: $fidposting');
    });
    return _result;
  }

  Future<void> _insertPosting(BuildContext context) async {
    try {
      if (_checkValidate()) {
        _loadData();
        postingDB.insert(posting);

        // userSignup =
        //     await AuthServices.signUp(controlEmail.text, controlPassword.text);

        // if (userSignup != null) {
        //   _loadData();
        //   userDB.insert(user);
        // } else if (userSignup == null) {
        //   _message = "Daftar user gagal";
        //   print(_message);
        //   Alertku.showAlertCustom(context, _message);
        // }
      } else {
        _message = "Content harus diisi";
        print(_message);
        Alertku.showAlertCustom(context, _message);
      }
    } catch (e) {
      print(e);
    }
  }

  Future getImage() async {
    File image;
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    // var image = ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = image;
        _nameImage = _path.basename(image.path);
        print(_nameImage);
        // _listImage.add(_image);
        // _imagePath = image.path;
        // _nameImage = splitPath(_imagePath);
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
    _urlImage = urlDownl.toString();

    print('Url Gambar : $_urlImage');
    return _urlImage;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.red[700],
            ),
            onPressed: () {
              // print('Pop ke Profil');
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Buat Postingan',
            style:
                TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              width: double.infinity,
              height: 50,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.redAccent,
                    backgroundImage:
                        (user.urlPhoto == "" || user.urlPhoto == null)
                            ? AssetImage("img/noprofile.png")
                            : NetworkImage(user.urlPhoto),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(user.username)
                  ),
                  Spacer(),
                  IconButton(
                      icon: Icon(Icons.image),
                      iconSize: 20,
                      onPressed: () {
                        getImage();
                      }),
                  IconButton(
                      icon: Icon(Icons.upload_file),
                      iconSize: 20,
                      onPressed: () {}),

                  // FlatButton.icon(
                  //     onPressed: () {},
                  //     icon: Icon(Icons.upload_file),
                  //     label: Text('Lampirkan'))
                ],
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey[300],
            ),
            (_image == null)
                ? Container()
                : Container(
                    color: Colors.grey[200],
                    height: 80,
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Image.file(_image)),
                  ),
            // : ListView.builder(
            //   scrollDirection: Axis.horizontal,
            //     itemCount: _listImage.length, itemBuilder: (_, index) {
            //       return Container(
            //         height: 80,
            //       );
            //     }),

            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              color: Colors.white,
              width: double.infinity,
              child: TextField(
                onChanged: (value) {
                  if (fidposting == null) {
                    getPostingID();
                    print('idposting change: $fidposting');
                  } else {
                    print('idposting change wes: $fidposting');
                  }
                },
                controller: controllerPosting,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Tulis postingan disini...'),
                maxLines: null,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 5,
          onPressed: () {
            _insertPosting(context);
            Navigator.pop(context);
          },
          backgroundColor: Colors.red[700],
          child: Icon(
            Icons.send,
            size: 25,
          ),
        ),
      ),
    );
  }
}
