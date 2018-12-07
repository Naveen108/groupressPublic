import 'package:flutter/material.dart';
import 'package:groupres/Components/floating_action_button.dart';
import 'package:groupres/DataModels/user_model.dart';
import 'package:groupres/DataModels/group_rest_model.dart';
import 'package:groupres/Screens/GroupCartWidget/index.dart';
import 'package:groupres/Screens/MenuScreen/index.dart';
import 'package:groupres/Screens/MyCartWidget/index.dart';
import 'package:groupres/Components/custom_drawer.dart';

class CartScreen extends StatefulWidget {
  final GroupRestModel grouprestmodel = GroupRestModel();
  @override
  _CartScreen createState() => new _CartScreen(grouprestmodel: grouprestmodel);
}

class _CartScreen extends State<CartScreen> {
  final GroupRestModel grouprestmodel;
  _CartScreen({this.grouprestmodel});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            floatingActionButton: new FancyFab(grouprestmodel: grouprestmodel),
            drawer: new CustomDrawer(index: 2),
            appBar: AppBar(
              actions: <Widget>[
                // action button
                IconButton(
                  icon: Icon(Icons.restaurant_menu),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MenuScreen()));
                  },
                ),
              ],
              backgroundColor: new Color.fromRGBO(98, 0, 238, 0.5),
              bottom: TabBar(
                tabs: [
                  Tab(
                      text: 'My Cart',
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      )),
                  Tab(
                      text: 'Group Cart',
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      )),
                ],
              ),
              title: new Center(
                child: Text(
                  'Rivew Orders',
                  style: new TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Roboto',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            body: TabBarView(
              children: [
                new MyCartWidget(grouprestmodel: grouprestmodel),
                new GroupCartWidget(
                    group: UserModel.currentGroup,
                    grouprestmodel: grouprestmodel),
                //new Text('Add Something')
              ],
            ),
          ),
        ));
  }
}
