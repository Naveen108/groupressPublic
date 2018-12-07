import 'package:flutter/material.dart';
import 'package:groupres/Screens/Login/index.dart';
import 'package:groupres/Screens/MenuScreen/index.dart';
import 'package:groupres/Screens/CreateGroup/index.dart';
import 'package:groupres/Screens/CartScreen/index.dart';
import 'package:groupres/DataModels/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:groupres/Screens/InviteFriend/index.dart';

class CustomDrawer extends StatelessWidget {
  final int index;
  CustomDrawer({this.index});
  @override
  Widget build(BuildContext context) {
    print(UserModel.username);
    print(UserModel.currentGroup);
    print(UserModel.userPhoneNumber);
    //logut function
    logmeout() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userphone', "").then((data) {
        prefs.setString('username', '');
        prefs.setString('group', 'GR');
        prefs.setString('useremail', '');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    }

    _logmeout() {
      //calling a async function
      print('called log out');
      logmeout();
    }

    Size screensizes = MediaQuery.of(context).size;
    return new Drawer(
      elevation: 16.0,
      child: new Container(
        decoration: new BoxDecoration(
          color: Colors.white,
        ),
        child: new ListView(
          children: <Widget>[
            new Divider(height: 5.0),
            new Container(
              height: 100.0,
              decoration: new BoxDecoration(
                color: Colors.blueGrey[50],
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new ExactAssetImage("assets/vegfood.jpg"),
                  colorFilter: new ColorFilter.mode(
                      Color.fromRGBO(98, 0, 238, 0.4), BlendMode.dstATop),
                ),
              ),
              child: Row(
                children: <Widget>[
                  new SizedBox(
                    height: 100.0,
                    width: screensizes.width / 4.0,
                    child: new Padding(
                      padding: new EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 15.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.purple,
                        child: Icon(
                          Icons.person,
                          size: 50.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  new SizedBox(
                    height: 100.0,
                    width: screensizes.width / 2.1,
                    child: new Padding(
                      padding: new EdgeInsets.only(
                        top: 0.0,
                        left: 15.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            UserModel.username,
                            style: new TextStyle(
                                fontSize: 18.0,
                                color: Colors.black87.withOpacity(0.9)),
                          ),
                          new Text(
                            UserModel.currentGroup,
                            style: new TextStyle(
                                fontSize: 18.0,
                                color: Colors.black87.withOpacity(0.9)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Divider(height: 5.0),
            new ListTile(
                title: new Text("Menu"),
                trailing: new Icon(
                  Icons.restaurant_menu,
                  color: Colors.black,
                ),
                onTap: () {
                  if (index != 0) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MenuScreen()));
                  } else {
                    Navigator.of(context).pop();
                  }
                }),
            new Divider(height: 5.0),
            new ListTile(
                title: new Text("Groups"),
                trailing: new Icon(
                  Icons.group_work,
                  color: Colors.black,
                ),
                onTap: () {
                  if (index != 1) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => CreateGroup()));
                  } else {
                    Navigator.of(context).pop();
                  }
                }),
            new Divider(height: 5.0),
            new ListTile(
                title: new Text("Carts"),
                trailing: new Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
                onTap: () {
                  if (index != 2) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => CartScreen()));
                  } else {
                    Navigator.of(context).pop();
                  }
                }),
            new Divider(height: 5.0),
            new ListTile(
              title: new Text("Friends"),
              trailing: new Icon(
                Icons.group_add,
                color: Colors.black,
              ),
              onTap: () {
                if (index != 3) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => InviteFriend()));
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
            new Divider(height: 5.0),
            new ListTile(
              title: new Text("Logout"),
              trailing: new Icon(
                Icons.settings_power,
                color: Colors.black,
              ),
              onTap: () {
                _logmeout();
              },
            ),
            new Divider(height: 5.0),
          ],
        ),
      ),
    );
  }
}
