import 'package:flutter/material.dart';
import 'package:groupres/DataModels/menu_item_class.dart';
import 'package:groupres/DataModels/group_rest_model.dart';

class MenuItem extends StatelessWidget {
  MenuItemClass menuData;
  final GroupRestModel grouprestmodel;

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;

    return new Container(
        height: screensize.height / 3.1,
        width: screensize.width / 1.0,
        margin: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 8.0,
        ),
        decoration: new BoxDecoration(
          color: Colors.white,
        ),
        child: new Card(
            margin: const EdgeInsets.all(0.0),
            elevation: 8.0,
            child: new Row(
              children: <Widget>[
                new SizedBox(
                  width: screensize.width / 2.5,
                  height: screensize.height / 3.1,
                  child:
                      new Image.network(menuData.itemImage, fit: BoxFit.fill),
                ),
                new SizedBox(
                  width: screensize.width / 1.0 - screensize.width / 2.0,
                  height: screensize.height / 3.1,
                  child: new Column(
                    children: <Widget>[
                      new Padding(
                          padding: new EdgeInsets.only(top: 15.0, bottom: 10.0),
                          child: new Align(
                            alignment: Alignment.topCenter,
                            child: new Text(
                              menuData.itemTitle,
                              style: new TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Roboto',
                                color: new Color(0xFF212121),
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          )),
                      new Padding(
                          padding: new EdgeInsets.only(top: 5.0, left: 1.0),
                          child: new Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              menuData.itemDetails,
                              maxLines: 10,
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.center,
                            ),
                          )),
                      new Padding(
                          padding: new EdgeInsets.only(top: 30.0),
                          child: new Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: <Widget>[
                                  new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        new Padding(
                                            padding:
                                                new EdgeInsets.only(top: 25.0),
                                            child: new Align(
                                              alignment: Alignment.topCenter,
                                              child: new Text(' Rs ' +
                                                  menuData.itemCost.toString() +
                                                  ''),
                                            ))
                                      ]),
                                  new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        new IconButton(
                                          onPressed: () {
                                            grouprestmodel
                                                .increaseQuantityM(menuData)
                                                .then((data) {
                                              grouprestmodel.fetchMenuItems();
                                            });
                                          },
                                          icon: new Icon(
                                            Icons.add_circle,
                                            size: 20.0,
                                          ),
                                        ),
                                        new Padding(
                                          padding:
                                              new EdgeInsets.only(top: 5.0),
                                          child: new Align(
                                            alignment: Alignment.topCenter,
                                            child: new Text(menuData
                                                .itemQuantity
                                                .toString()),
                                          ),
                                        ),
                                        new IconButton(
                                          onPressed: () {
                                            grouprestmodel
                                                .decreaseQuantity(menuData)
                                                .then((data) {
                                              grouprestmodel.fetchMenuItems();
                                            });
                                          },
                                          icon: new Icon(
                                            Icons.remove_circle,
                                            size: 20.0,
                                          ),
                                        ),
                                      ])
                                ],
                              )))
                    ],
                  ),
                ),
              ],
            )));
  }

  MenuItem({this.menuData, this.grouprestmodel});
}
