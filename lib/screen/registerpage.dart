import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sijuki/auth_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sijuki/bloc/visibility_bloc.dart';
// import 'package:sijuki/screen/mainpage.dart';
import 'package:sijuki/widget/colorloader.dart';
import 'package:sijuki/widget/customalert.dart';
import 'package:sijuki/bloc/loading_bloc.dart';
import 'package:sijuki/model/user.dart';
import 'package:sijuki/widget/customclipper.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TextEditingController controlEmail = TextEditingController();
  TextEditingController controlPassword = TextEditingController();
  TextEditingController controlPasswordConfirm = TextEditingController();
  TextEditingController controlUsername = TextEditingController();
  // FocusNode _focus = new FocusNode();

  // bool _isRegister = false;
  int fiduser;
  bool _result;
  bool _validateUsername = true;
  bool _validateEmail = true;
  bool _validatePassword = true;
  bool _validatePasswordConfirm = true;
  String _message = "";
  FirebaseUser userSignup;

  User user;
  UserDB userDB;

  @override
  void initState() {
    super.initState();
    user = new User();
    userDB = new UserDB();
    getUserID();
    print('iduser init: $fiduser');
  }

  void getUserID() async {
    fiduser = await userDB.getMaxID();
  }

  bool _checkValidate() {
    _validateEmail = true;
    _validatePassword = true;
    _validatePasswordConfirm = true;
    _validateUsername = true;
    _result = true;

    setState(() {
      if (controlEmail.text.trim() == "") {
        _validateEmail = false;
        _result = false;
      }
      if (controlPassword.text.trim() == "") {
        _validatePassword = false;
        _result = false;
      }
      if (controlPasswordConfirm.text.trim() == "") {
        _validatePasswordConfirm = false;
        _result = false;
      }
      if (controlUsername.text.trim() == "") {
        _validateUsername = false;
        _result = false;
      }
      print('iduser check: $fiduser');
    });
    return _result;
  }

  _loadData() {
    user.iduser = fiduser;
    user.username = controlUsername.text;
    user.email = controlEmail.text;
    user.password = controlPassword.text;
  }

  Future<void> _registerUser(BuildContext context, LoadingBloc bloc) async {
    try {
      if (_checkValidate()) {
        bloc.add(LoadingEvent.to_show);
        userSignup =
            await AuthServices.signUp(controlEmail.text, controlPassword.text);
        bloc.add(LoadingEvent.to_hide);

        if (userSignup != null) {
          _loadData();
          userDB.insert(user);
        } else if (userSignup == null) {
          _message = "Daftar user gagal";
          print(_message);
          Alertku.showAlertCustom(context, _message);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    VisibilityBloc bloc = BlocProvider.of<VisibilityBloc>(context);
    LoadingBloc blocLoading = BlocProvider.of<LoadingBloc>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<LoadingBloc, bool>(
        builder: (context, currentIsShowLoading) => Scaffold(
          body: AbsorbPointer(
            absorbing: currentIsShowLoading,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                ),
                Positioned(
                  bottom: 0,
                  child: ClipPath(
                    clipper: ClipperRegister(),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                        color: Colors.red
                        // decoration: BoxDecoration(
                        //     color: Colors.red,
                        //     borderRadius: BorderRadius.circular(20)),
                        ),
                  ),
                ),
                ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(10,
                          MediaQuery.of(context).size.height * 0.18, 10, 10),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.75,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1.5, color: Colors.red),
                          borderRadius: BorderRadius.circular(15)),
                      child: BlocBuilder<VisibilityBloc, bool>(
                        builder: (context, currentIsShowPassword) => Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                              child: Text(
                                'REGISTER',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                              child: TextField(
                                onChanged: (value) {},
                                controller: controlUsername,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.people_outline),
                                    hintText: "Username",
                                    labelText: "Username",
                                    errorText: (_validateUsername)
                                        ? null
                                        : 'Username harus diisi'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                              child: TextField(
                                onChanged: (value) {},
                                controller: controlEmail,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.email),
                                    hintText: "Email",
                                    labelText: "Email",
                                    errorText: (_validateEmail)
                                        ? null
                                        : 'Email harus diisi'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                              child: TextField(
                                // focusNode: _focus,
                                onChanged: (value) {},
                                controller: controlPassword,
                                keyboardType: TextInputType.text,
                                obscureText: currentIsShowPassword,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.vpn_key),
                                    // suffixIcon: GestureDetector(
                                    //     onTap: () {
                                    //       print('focus: Pass');
                                    //       bloc.add((currentIsShow == true)
                                    //           ? VisibilityEvent.to_hide
                                    //           : VisibilityEvent.to_show);
                                    //     },
                                    //     child: Icon((currentIsShow == true)
                                    //         ? Icons.visibility
                                    //         : Icons.visibility_off)),
                                    hintText: "Password",
                                    labelText: "Password",
                                    errorText: (_validatePassword)
                                        ? null
                                        : 'Password harus diisi'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                              child: TextField(
                                //focusNode: _focus,
                                onChanged: (value) {},
                                controller: controlPasswordConfirm,
                                keyboardType: TextInputType.text,
                                obscureText: currentIsShowPassword,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.vpn_key),
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          //print('focus: Pass Conf');
                                          print('iduser ontap: $fiduser');
                                          bloc.add(
                                              (currentIsShowPassword == true)
                                                  ? VisibilityEvent.to_hide
                                                  : VisibilityEvent.to_show);
                                        },
                                        child: Icon(
                                            (currentIsShowPassword == true)
                                                ? Icons.visibility
                                                : Icons.visibility_off)),
                                    hintText: "Password Confirm",
                                    labelText: "Password Confirm",
                                    errorText: (_validatePasswordConfirm)
                                        ? null
                                        : 'Password Confirm harus diisi'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: (currentIsShowLoading)
                                  ? ColorLoader()
                                  : Container(
                                      width: 200,
                                      child: RaisedButton(
                                        onPressed: () async {
                                          print('Go to page Main');
                                          _registerUser(context, blocLoading);
                                          
                                        },
                                        shape: StadiumBorder(),
                                        color: Colors.red,
                                        child: Text(
                                          'SIGN UP',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
