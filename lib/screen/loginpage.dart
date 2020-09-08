import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sijuki/auth_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sijuki/bloc/loading_bloc.dart';
import 'package:sijuki/bloc/visibility_bloc.dart';
import 'package:sijuki/screen/registerpage.dart';
import 'package:sijuki/widget/colorloader.dart';
import 'package:sijuki/widget/customalert.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TextEditingController controlEmail = TextEditingController();
  TextEditingController controlPassword = TextEditingController();

  bool _validateEmail = true;
  bool _validatePassword = true;
  bool _result = true;
  String _message = "";
  FirebaseUser userLogin;
  bool _isLogin = false;

  // Future<void> _showAlert(BuildContext context, String aMessage) {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         // title: Text('WARNING'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             Icon(Icons.warning_amber_rounded,
  //                 size: 70, color: Colors.yellow[900]),
  //             Text(aMessage)
  //           ],
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('OK'),
  //             color: Colors.blueAccent,
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  void dispose() {
    super.dispose();
  }

  bool _checkValidate() {
    _validateEmail = true;
    _validatePassword = true;
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
    });
    return _result;
  }

  Future<void> _handleSubmit(BuildContext context, LoadingBloc bloc) async {
    try {
      if (_checkValidate()) {
        //Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
        
        // setState(() {
        //   _isLogin = true;
        // });
        bloc.add(LoadingEvent.to_show);
        userLogin =
            await AuthServices.signIn(controlEmail.text, controlPassword.text);
        //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        bloc.add(LoadingEvent.to_hide);
        // setState(() {
        //   _isLogin = false;
        // });

        if (userLogin == null) {
          _message = "Email dan password salah";
          print(_message);
          Alertku.showAlertCustom(context, _message);
          // _showAlert(context, _message);
          // setState(() {});
        }
      }
      // else {
      //   print(_message);
      //   //_showAlert(context, message);
      // }
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
                ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(10,
                          MediaQuery.of(context).size.height * 0.18, 10, 10),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.7,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1.5, color: Colors.red),
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
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
                          BlocBuilder<VisibilityBloc, bool>(
                            builder: (context, currentIsShowPassword) =>
                                Padding(
                              padding: const EdgeInsets.all(20),
                              child: TextField(
                                onChanged: (value) {},
                                controller: controlPassword,
                                keyboardType: TextInputType.text,
                                obscureText: currentIsShowPassword,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.vpn_key),
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          bloc.add((currentIsShowPassword == true)
                                              ? VisibilityEvent.to_hide
                                              : VisibilityEvent.to_show);
                                        },
                                        child: Icon((currentIsShowPassword == true)
                                            ? Icons.visibility
                                            : Icons.visibility_off)),
                                    hintText: "Password",
                                    labelText: "Password",
                                    errorText: (_validatePassword)
                                        ? null
                                        : 'Password harus diisi'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: (currentIsShowLoading)
                                ? ColorLoader()
                                : Container(
                                    width: 200,
                                    child: RaisedButton(
                                      onPressed: () async {
                                        print('Go to page Main');
                                        
                                        //setState(() {
                                          //_isLogin = true;
                                          _handleSubmit(context, blocLoading);
                                          //_isLogin = false;
                                        //});
                                        // blocLoading.add(LoadingEvent.to_hide);
                                        // ColorLoader();
                                        // Navigator.of(context).push(
                                        //   new MaterialPageRoute(
                                        //       builder: (context) => new MainPage(
                                        //             userLogin: null,
                                        //           )),
                                        // );
                                      },
                                      shape: StadiumBorder(),
                                      color: Colors.red,
                                      child: Text(
                                        'L O G I N',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Belum punya akun,  '),
                                  GestureDetector(
                                    onTap: () {
                                      print('Go to page Register');

                                      Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                new RegisterPage()),
                                      );
                                    },
                                    child: Text(
                                      'Daftar disini',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline),
                                    ),
                                  )
                                ],
                              ))
                        ],
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
