import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:sijuki/widget/customalert.dart';
import 'package:sijuki/bloc/mode_bloc.dart';
import 'mainpage.dart';
import 'package:sijuki/model/user.dart';

class SettingPage extends StatefulWidget {
  final User userLogin;
  const SettingPage({
    Key key,
    @required this.userLogin,
  }) : super(key: key);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // bool _value = false;
  User user = new User();
  UserDB userDB = new UserDB();

  @override
  void initState() {
    super.initState();
    user = widget.userLogin;
  }

  @override
  Widget build(BuildContext context) {
    ModeBloc blocMode = BlocProvider.of<ModeBloc>(context);
          
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<ModeBloc, int>(
        builder: (context, idXMode) => Scaffold(
          appBar: AppBar(
            backgroundColor: (idXMode == 1) ? Colors.black : Colors.white,
            
            // leading: IconButton(
            //   icon: Icon(
            //     Icons.arrow_back_ios,
            //     color: Colors.red[700],
            //   ),
            //   onPressed: () {
            //     print('Pop ke Profil');
                
            //     // Navigator.of(context).push(
            //     //   MaterialPageRoute(builder: (context) => MainPage(userLogin: user,)),
            //     // );
            //     Navigator.pop(context);
            //   },
            // ),
            title: Text(
              'Pengaturan',
              style: TextStyle(
                  color: Colors.red[700], fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ListTileSwitch(
                    leading: Icon(Icons.brightness_2),
                    value: (idXMode == 1) ? true : false,
                    onChanged: (value) {
                      if (!value)
                        blocMode.add(ModeEvent.to_light);
                      else
                        blocMode.add(ModeEvent.to_dark);

                      //print('mode dart: $idXMode');
                      // print(value);
                      
                      // setState(() {
                      //   _value = value;
                      // });
                    },
                    title: Text('Mode Gelap')),
                Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Log Out'),
                  subtitle: Text('Keluar dari aplikasi'),
                  onTap: () {
                    Alertku.alertLogout(context);
                  },
                ),
                Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
