import 'dart:async';
import 'package:flutter/material.dart';
import 'package:groupres/DataModels/menu_item_class.dart';
import 'package:groupres/DataModels/group_rest_model.dart';

class MyCartWidgetItem extends StatelessWidget {
  final GroupRestModel grouprestmodel;
  MenuItemClass cartData;
  Future<dynamic> quantityinc;
  Future<dynamic> quantitydec;

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;

    Widget cart(MenuItemClass cartData) {
      return new Container(
        height: screensize.height / 10.0,
        width: screensize.width / 1.0,
        margin: const EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 0.0,
        ),
        decoration: new BoxDecoration(
          color: Colors.white,
        ),
        child: new Row(
          children: <Widget>[
            new SizedBox(
              width: screensize.width / 1.0 - screensize.width / 1.3,
              height: 20.0,
              child: new Padding(
                padding: new EdgeInsets.only(top: 8.0),
                child: new Align(
                  alignment: Alignment.topLeft,
                  child: new Text(
                    cartData.itemTitle,
                    style: new TextStyle(
                      fontSize: 15.0,
                      fontFamily: 'Roboto',
                      color: new Color(0xFF212121),
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ),
            new SizedBox(
              width: screensize.width / 1.0 - screensize.width / 1.8,
              height: 20.0,
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(
                      top: 0.0,
                      left: 30.0,
                    ),
                    child: new Align(
                      alignment: Alignment.topCenter,
                      child: new IconButton(
                        onPressed: () {
                          grouprestmodel
                              .increaseQuantity(cartData)
                              .then((data) {
                            grouprestmodel.fetchMyCartItems();
                          });
                        },
                        icon: new Icon(
                          Icons.add_circle,
                          size: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  new Padding(
                    padding:
                        new EdgeInsets.only(top: 8.0, right: 5.0, left: 5.0),
                    child: new Align(
                      alignment: Alignment.topCenter,
                      child: new Text(
                        cartData.itemQuantity.toString(),
                        style: new TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF212121),
                        ),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 0.0),
                    child: new Align(
                      alignment: Alignment.topCenter,
                      child: new IconButton(
                        onPressed: () {
                          grouprestmodel
                              .decreaseQuantity(cartData)
                              .then((data) {
                            grouprestmodel.fetchMyCartItems();
                          });
                        },
                        icon: new Icon(
                          Icons.remove_circle,
                          size: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildTiles(MenuItemClass cartData) {
      print(cartData.friends);
      return Card(
          child: ListTile(
              title: cart(cartData),
              trailing: new Padding(
                padding: new EdgeInsets.only(
                  top: 10.0,
                ),
                child: Text(
                    ((cartData.itemQuantity) * (cartData.itemCost)).toString()),
              )));
    }

    return _buildTiles(cartData);
  }

  MyCartWidgetItem({this.cartData, this.grouprestmodel});
}
