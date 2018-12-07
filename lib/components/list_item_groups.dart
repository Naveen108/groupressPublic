import 'dart:async';
import 'package:flutter/material.dart';
import 'package:groupres/DataModels/list_item_class.dart';
import 'package:groupres/DataModels/user_model.dart';
import 'package:groupres/DataModels/group_rest_model.dart';
import 'package:groupres/DataModels/create_group_class.dart';

class ListItemGroups extends StatelessWidget {
  final GroupRestModel grouprestmodel;
  ListItemClass listData;
  var ontap;
  var onlongpress;
  var ondoubletap;
  var onslideright;
  var onslideleft;
  @override
  Widget build(BuildContext context) {
    CreateNewGroup group = new CreateNewGroup(
        byUser: UserModel.userPhoneNumber,
        groupName: listData.listItemName,
        group_id: listData.group_id);
    Size screensize = MediaQuery.of(context).size;

    //Delete Group for superuser
    Future<Null> _groupLongTap() async {
      return showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return new AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
            title: new Text(listData.listItemName),
            content: new Text(listData.listItemName +
                ' has ${listData.members} Members . \n \bWhat do you want to do ?'),
            actions: <Widget>[
              new FlatButton(
                  child: new Text('Delete Group'),
                  onPressed: () {
                    grouprestmodel.deleteGroup(group).then((data) async {
                      Navigator.of(context).pop();
                    });
                  }),
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }

    return GestureDetector(
        onLongPress: () {
          _groupLongTap();
        },

        // When the child is tapped, show a snackbar
        onTap: () {
          UserModel.currentGroup = listData.listItemName;
          UserModel.superuser = listData.superUser;
          UserModel.groupId = listData.group_id;
          UserModel.cartId = listData.cart_id;
          final snackBar = SnackBar(
              content: Text('Selected Group: ' + listData.listItemName));
          Scaffold.of(context).showSnackBar(snackBar);
        },
        child: new Container(
          height: screensize.height / 13.0,
          width: screensize.width / 1.2,
          margin: const EdgeInsets.symmetric(
            vertical: 0.0,
            horizontal: 0.0,
          ),
          decoration: new BoxDecoration(
            color: Colors.white,
          ),
          child: new Card(
              elevation: 4.0,
              margin: const EdgeInsets.all(1.0),
              child: ListTile(
                leading: new Text(
                  listData.listItemName,
                  style: new TextStyle(
                    fontSize: 17.0,
                    fontFamily: 'Roboto',
                    color: new Color(0xFF212121),
                  ),
                  overflow: TextOverflow.clip,
                ),
                trailing: new Text(
                  'Members: ' + '${listData.members.toString()}',
                  style: new TextStyle(
                    fontSize: 17.0,
                    fontFamily: 'Roboto',
                    color: new Color(0xFF212121),
                  ),
                  overflow: TextOverflow.clip,
                ),
              )),
        ));
  }

  ListItemGroups(
      {this.listData,
      this.ondoubletap,
      this.onlongpress,
      this.onslideleft,
      this.onslideright,
      this.ontap,
      this.grouprestmodel});
}
