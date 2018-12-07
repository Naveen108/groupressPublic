//MenuScreen
import 'package:flutter/material.dart';
import 'package:groupres/Components/menu_item.dart';
import 'package:groupres/Screens/CartScreen/index.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:groupres/DataModels/group_rest_model.dart';
import 'package:groupres/Components/custom_drawer.dart';

class MenuScreen extends StatelessWidget {
  final GroupRestModel grouprestmodel = new GroupRestModel();
  final index = 0;

  @override
  Widget build(BuildContext context) {
    grouprestmodel.fetchMenuItems();

    Size screensizes = MediaQuery.of(context).size;
    return ScopedModel<GroupRestModel>(
      model: grouprestmodel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => CartScreen()));
                },
              ),
            ],
            title: new Center(
              child: new Text(
                'Menu',
                style: new TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Roboto',
                  color: Colors.white,
                ),
                overflow: TextOverflow.clip,
              ),
            ),
            backgroundColor: new Color.fromRGBO(98, 0, 238, 0.5),
          ),
          drawer: new CustomDrawer(index: index),
          body: new ScopedModelDescendant<GroupRestModel>(
              rebuildOnChange: true,
              builder: (context, child, grouprestmodel) {
                print(
                    "inside menu screen = ${grouprestmodel.menuListCollection.length}");
                return grouprestmodel.menuListCollection.length != 0
                    ? new SizedBox(
                        width: screensizes.width / 1.0,
                        height: screensizes.height /
                            1.0, //- screensizes.height / 8.0,
                        child: new Container(
                          decoration: new BoxDecoration(
                            color: new Color.fromRGBO(98, 0, 238, 0.1),
                          ),
                          child: new Padding(
                            padding: new EdgeInsets.only(
                                top: 0.0, left: 5.0, right: 5.0),
                            child: new Align(
                              alignment: Alignment.topCenter,
                              child: ListView.builder(
                                itemBuilder: (context, index) => (MenuItem(
                                      menuData: grouprestmodel
                                          .menuListCollection[index],
                                      grouprestmodel: grouprestmodel,
                                    )),
                                itemCount:
                                    grouprestmodel.menuListCollection.length,
                              ),
                            ),
                          ),
                        ),
                      )
                    : new Center(child: new CircularProgressIndicator());
              }),
        ),
      ),
    );
  }
}
