import 'package:flutter/material.dart';
import 'package:groupres/Screens/InvitedCode/index.dart';
import 'package:groupres/Screens/Register/index.dart';
import 'package:groupres/Screens/SplashScreen/index.dart';
import 'package:groupres/Screens/Login/index.dart';
import 'package:groupres/Screens/MenuScreen/index.dart';
import 'package:groupres/Screens/InviteFriend/index.dart';
import 'package:groupres/Screens/CartScreen/index.dart';

class Routes {
  final approutes = <String, WidgetBuilder>{
    '/login': (context) => LoginPage(),
    '/Register': (context) => Register(),
    '/InvitedCode': (context) => InvitedCode(),
    '/splashscreen': (context) => SplashScreen(),
    '/MenuScreen': (context) => MenuScreen(),
    '/InviteFriend': (context) => InviteFriend(),
    '/CartScreen': (context) => CartScreen(),
  };
  Routes() {
    runApp(MaterialApp(
      title: "Group Resturant App",
      routes: approutes,
      home: new SplashScreen(),
      debugShowCheckedModeBanner: false,
    ));
  }
}
