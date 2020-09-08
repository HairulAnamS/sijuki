import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sijuki/bloc/mode_bloc.dart';
import 'package:sijuki/screen/loginpage.dart';
import 'package:sijuki/screen/mainpage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/visibility_bloc.dart';
import 'bloc/loading_bloc.dart';
import 'bloc/tab_bloc.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider<VisibilityBloc>(create: (context) => VisibilityBloc(true)),
        BlocProvider<LoadingBloc>(create: (context) => LoadingBloc(false)), 
        BlocProvider<TabBloc>(create: (context) => TabBloc(0)),
        BlocProvider<ModeBloc>(create: (context) => ModeBloc(0))
      ],
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: (firebaseUser == null)
            ? LoginPage()
            : MainPage(userLogin: firebaseUser),
        // home: BlocProvider<VisibilityBloc>(
        //   create: (context) => VisibilityBloc(true),
        //   child: (firebaseUser == null)
        //       ? LoginPage()
        //       : MainPage(userLogin: firebaseUser),
        // ),
      ),
    );

    // return (firebaseUser == null) ? LoginPage() : MainPage(userLogin: firebaseUser);
  }
}
