import 'package:flutter/material.dart';
import 'package:groupres/Components/input_text_form_field.dart';
import 'package:groupres/DataModels/menu_item_class.dart';
import 'package:groupres/DataModels/group_rest_model.dart';

class NewItem extends StatefulWidget {
  final GroupRestModel grouprestmodel;
  NewItem({this.grouprestmodel});
  @override
  _NewItem createState() => new _NewItem(grouprestmodel: grouprestmodel);
}

class _NewItem extends State<NewItem> {
  final GroupRestModel grouprestmodel;
  _NewItem({this.grouprestmodel});
  static int itemQuantity = 0;
  final formKey = GlobalKey<FormState>();
  String itemTitle;
  String itemCost;

  addNewItem() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      print('$itemTitle,$itemCost,$itemQuantity');
      MenuItemClass cartItem = new MenuItemClass();
      cartItem.itemTitle = itemTitle;
      cartItem.itemid = -1;
      cartItem.itemCost = int.parse(itemCost);
      cartItem.itemQuantity = itemQuantity;
      print('$itemQuantity and query ${cartItem.itemQuantity} ');
      if (itemQuantity != 0) {
        await grouprestmodel.insertNewItem(cartItem).then((data) {
          print('insertNewItem recieved $data');
          if (data == true) {
            formKey.currentState.reset();
            setState(() {
              itemQuantity = 0;
            });
            print('i was to navigate in newitem');
          }
        });
      } else {
        print('quantity should be more than 0');
      }
    }
  }

  increaseQuantity() {
    setState(() {
      itemQuantity++;
      print(itemQuantity);
    });
  }

  decreasesQuantity() {
    if (itemQuantity > 0) {
      setState(() {
        itemQuantity--;
      });
    } else {
      print('i am zero ');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    return new Container(
      height: screensize.height / 4.5,
      width: screensize.width / 1.0,
      margin: const EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: 0.0,
      ),
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
      child: new Card(
        margin: const EdgeInsets.all(0.0),
        elevation: 8.0,
        child: new Form(
          key: formKey,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new SizedBox(
                  height: screensize.height / 4.5,
                  width: screensize.width / 2.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Padding(
                          padding: new EdgeInsets.only(top: 0.0),
                          child: new Align(
                            alignment: Alignment.topCenter,
                            child: new InputTextFormField(
                              texttype: TextInputType.text,
                              hinttext: "Your Item Name Here",
                              iconType: new Icon(Icons.work),
                              errortext: "Enter Item Name",
                              errorcheck: "",
                              onSave: (val) => itemTitle = val,
                            ),
                          )),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                              padding: new EdgeInsets.only(
                                top: 10.0,
                                left: 15.0,
                              ),
                              child: new Align(
                                alignment: Alignment.topCenter,
                                child: new IconButton(
                                  //key: quantitypluskey,
                                  onPressed: increaseQuantity,
                                  //grouprestmodel.increaseQuantityG(cartData);

                                  icon: new Icon(
                                    Icons.add_circle,
                                    size: 20.0,
                                  ),
                                ),
                              )),
                          new Padding(
                            padding: new EdgeInsets.only(
                                top: 10.0, right: 10.0, left: 10.0),
                            child: new Align(
                              alignment: Alignment.topCenter,
                              child: new Text(
                                itemQuantity.toString(),
                                // cartData.itemQuantity
                                //     .toString(), //how to use integer
                                style: new TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: 'Roboto',
                                  color: new Color(0xFF212121),
                                  //fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                          new Padding(
                              padding: new EdgeInsets.only(top: 10.0),
                              child: new Align(
                                alignment: Alignment.topCenter,
                                child: new IconButton(
                                  //key: quantitypluskey,
                                  onPressed: decreasesQuantity,
                                  //grouprestmodel.decreaseQuantityG(cartData);

                                  icon: new Icon(
                                    Icons.remove_circle,
                                    size: 20.0,
                                  ),
                                ),
                              )),
                        ],
                      )
                    ],
                  )),
              new SizedBox(
                height: screensize.height / 4.5,
                width: screensize.width / 2.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                        padding: new EdgeInsets.only(top: 0.0),
                        child: new Align(
                          alignment: Alignment.topCenter,
                          child: new InputTextFormField(
                            texttype: TextInputType.number,
                            hinttext: "Item Price Rs ?",
                            iconType: new Icon(Icons.work),
                            errortext: "Enter Item Price ",
                            errorcheck: "",
                            onSave: (val) => itemCost = val,
                          ),
                        )),
                    new Padding(
                        padding: new EdgeInsets.only(top: 10.0),
                        child: new Align(
                          alignment: Alignment.topCenter,
                          child: new IconButton(
                            //key: quantitypluskey,
                            onPressed: addNewItem,
                            icon: new Icon(
                              Icons.add_shopping_cart,
                              size: 40.0,
                              color: new Color.fromRGBO(98, 0, 238, 0.5),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
