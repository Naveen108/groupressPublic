//Splash screen
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:groupres/DataModels/config.dart';
import 'package:groupres/DataModels/user_model.dart';
import 'package:groupres/Screens/MenuScreen/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => new _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    connect2Db();
  }

  Future<Null> connect2Db() async {
    await Config.connectToDb().then((data) async {
      String userphonenumber = '';
      print('after connect i got this $data');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getKeys().length != 0) {
        print(prefs.getKeys().length);
        if (prefs.get('userphone') != null) {
          if (prefs.get('userphone').length != 0) {
            print('any user ? ' + prefs.getString('userphone'));
            userphonenumber = prefs.getString('userphone');
            UserModel.userPhoneNumber = prefs.getString('userphone');
            print(prefs.getString('userphone'));
            UserModel.username = prefs.getString('username');
            print(prefs.getString('username')); //why Null
            UserModel.currentGroup = prefs.getString('group');
            print(prefs.getString('group'));
            UserModel.superuser = UserModel.userPhoneNumber;
            print('$userphonenumber');
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MenuScreen()));
          } else {
            new Timer(Duration(seconds: 5), onClose);
            print("not navigate");
          }
        } else {
          new Timer(Duration(seconds: 5), onClose);
          print("not navigate");
        }
      } else {
        new Timer(Duration(seconds: 5), onClose);
        print("not navigate");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Stack(children: <Widget>[
      new Container(
        decoration: new BoxDecoration(
          color: new Color.fromRGBO(98, 0, 238, 0.4),
        ),
      ),
      new Container(
          decoration: new BoxDecoration(
              image: new DecorationImage(
            image: new ExactAssetImage("assets/SplashIcon.png"),
          )),
          child: new Padding(
              padding: new EdgeInsets.only(bottom: 20.0),
              child: new Align(
                alignment: Alignment.bottomCenter,
                child: new CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      new Color.fromRGBO(98, 0, 238, 1.0)),
                ),
              ))),
    ]));
  }

  void onClose() {
    Navigator.pushReplacementNamed(context, '/login');
  }
}
