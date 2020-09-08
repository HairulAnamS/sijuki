import 'package:flutter/material.dart';
import 'package:sijuki/auth_services.dart';
import 'package:provider/provider.dart';
import 'wrapper.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthServices.firebaseUserStream,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
