import 'package:flutter/material.dart';
import 'package:groupres/Components/group_cart_widget_item.dart';
import 'package:groupres/DataModels/group_rest_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:groupres/DataModels/user_model.dart';

class GroupCartWidget extends StatelessWidget {
  final GroupRestModel grouprestmodel;
  String group = UserModel.currentGroup;
  int finalPrice = 0;
  GroupCartWidget({this.group, this.grouprestmodel});

  @override
  Widget build(BuildContext context) {
    grouprestmodel.fetchGroupCartItems();
    Size screensize = MediaQuery.of(context).size;
    return ScopedModel<GroupRestModel>(
      model: grouprestmodel,
      child: new SizedBox(
        width: screensize.width / 1.0,
        height: screensize.height / 2.8,
        child: Container(
          height: screensize.height / 2.9,
          width: screensize.width / 1.0,
          margin: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 8.0,
          ),
          decoration: new BoxDecoration(
            color: Colors.white,
          ),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new ScopedModelDescendant<GroupRestModel>(
                  builder: (context, child, model) {
                return new ListTile(
                  leading: Icon(Icons.group_work),
                  title: Text(group),
                );
              }),
              new SizedBox(
                width: screensize.width / 1.0,
                height: screensize.height / 1.0 - screensize.height / 2.4,
                child: new Padding(
                  padding: new EdgeInsets.only(top: 0.0, left: 5.0, right: 5.0),
                  child: new Align(
                    alignment: Alignment.topCenter,
                    child: new ScopedModelDescendant<GroupRestModel>(
                        builder: (context, child, groupcartmodel) {
                      return ListView.builder(
                        itemBuilder: (context, index) => (GroupCartWidgetItem(
                              cartData: grouprestmodel.groupCartList[index],
                              grouprestmodel: grouprestmodel,
                            )),
                        itemCount: groupcartmodel.groupCartList.length,
                      );
                    }),
                  ),
                ),
              ),
              new ScopedModelDescendant<GroupRestModel>(
                builder: (context, child, groupcartmodel) {
                  return new Container(
                    padding: new EdgeInsets.only(top: 10.0),
                    height: screensize.height / 9.0,
                    width: screensize.width / 1.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 0.0,
                      horizontal: 0.0,
                    ),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                    ),
                    child: new Card(
                      elevation: 9.0,
                      child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Padding(
                              padding: new EdgeInsets.only(top: 8.0),
                              child: new Align(
                                alignment: Alignment.topLeft,
                                child: new Text(
                                  '   Detailed Bill',
                                  style: new TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: 'Roboto',
                                    color: new Color(0xFF212121),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                              )),
                          new Row(
                            children: <Widget>[
                              new SizedBox(
                                width: 180.0,
                                height: 20.0,
                                child: new Padding(
                                    padding: new EdgeInsets.only(top: 8.0),
                                    child: new Align(
                                      alignment: Alignment.topCenter,
                                      child: new Text(
                                        'Group Order Charges :',
                                        style: new TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                          color: new Color(0xFF212121),
                                          //fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.clip,
                                      ),
                                    )),
                              ),
                              new SizedBox(
                                width: 180.0,
                                height: 20.0,
                                child: new Padding(
                                    padding: new EdgeInsets.only(top: 8.0),
                                    child: new Align(
                                      alignment: Alignment.topCenter,
                                      child: new Text(
                                        'Rs ${groupcartmodel.groupOrderCharges.toString()}',
                                        style: new TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                          color: new Color(0xFF212121),
                                          //fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.clip,
                                      ),
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
