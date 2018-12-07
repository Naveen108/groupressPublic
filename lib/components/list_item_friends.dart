import 'package:flutter/material.dart';
import 'package:groupres/DataModels/list_item_class.dart';

class ListItemFriends extends StatelessWidget {
  ListItemClass listData;
  var ontap;
  var onlongpress;
  var ondoubletap;
  var onslideright;
  var onslideleft;

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    return GestureDetector(
      onLongPress: () {
        final snackBar = SnackBar(content: Text(listData.listItemName));
        Scaffold.of(context).showSnackBar(snackBar);
      },

      // When the child is tapped, show a snackbar
      onTap: () {
        final snackBar = SnackBar(
            content: Text('Your Group Friend  ' + listData.listItemName));
        Scaffold.of(context).showSnackBar(snackBar);
      },
      child: new Container(
        height: screensize.height / 12.0,
        width: screensize.width / 1.0,
        margin: const EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 0.0,
        ),
        decoration: new BoxDecoration(
          color: Colors.white,
        ),
        child: new Card(
            margin: const EdgeInsets.all(2.0),
            elevation: 4.0,
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
                'Phone:' + listData.phone.toString(),
                style: new TextStyle(
                  fontSize: 17.0,
                  fontFamily: 'Roboto',
                  color: new Color(0xFF212121),
                ),
                overflow: TextOverflow.clip,
              ),
            )),
      ),
    );
  }

  ListItemFriends(
      {this.listData,
      this.ondoubletap,
      this.onlongpress,
      this.onslideleft,
      this.onslideright,
      this.ontap});
}
