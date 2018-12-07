import 'package:flutter/material.dart';
import 'package:groupres/Components/input_text_form_field.dart';
import 'package:groupres/Components/list_item_groups.dart';
import 'package:groupres/Components/custom_drawer.dart';
import 'package:groupres/DataModels/group_rest_model.dart';
import 'package:groupres/DataModels/create_group_class.dart';
import 'package:groupres/DataModels/user_model.dart';
import 'package:groupres/Screens/CartScreen/index.dart';
import 'package:groupres/Screens/InviteFriend/index.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroup createState() => new _CreateGroup();
}

class _CreateGroup extends State<CreateGroup> {
  final GroupRestModel grouprestmodel = GroupRestModel();
  String groupname =
      UserModel.currentGroup != null ? UserModel.currentGroup : '';

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String newGroup;
  String user = UserModel.userPhoneNumber;
  void _createGroup() {
    print('Called me Create button');
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      CreateNewGroup group = CreateNewGroup();
      group.byUser = user;
      group.groupName = newGroup;

      if (newGroup != '') {
        formKey.currentState.reset();
        //for reset input box after addition
        grouprestmodel.createGroup(group).then((data) {
          String snackbarText;
          if (data == true) {
            snackbarText =
                '${UserModel.userPhoneNumber}  Added group With Name $newGroup';
          } else {
            snackbarText = 'Couldn\'t add new group:- $newGroup';
          }
          final snackbar = SnackBar(
            content: Text(snackbarText),
          );
          scaffoldKey.currentState.showSnackBar(snackbar);
        });
      } else {
        String snackbarText = 'Enter Group Name ';
        final snackbar = SnackBar(
          content: Text(snackbarText),
        );

        scaffoldKey.currentState.showSnackBar(snackbar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screensizes = MediaQuery.of(context).size;
    grouprestmodel.fetchGroupItems();
    return ScopedModel<GroupRestModel>(
      model: grouprestmodel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Groups',
        home: Scaffold(
          drawer: new CustomDrawer(index: 1
              //cartmodel: cartmodel,
              ),
          key: scaffoldKey,
          appBar: AppBar(
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.people),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => InviteFriend()));
                },
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => CartScreen()));
                },
              ),
            ],
            title: new Text(
                UserModel.username + ' \'s Groups'), //+ MenuModel.currentGroup
            backgroundColor: new Color.fromRGBO(98, 0, 238, 0.5),
          ),
          body: Container(
            decoration: new BoxDecoration(
              color: Colors.white12,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: new ExactAssetImage("assets/invitecode.jpg"),
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.2), BlendMode.dstATop),
              ),
            ),
            child: Column(
              children: <Widget>[
                new SizedBox(
                  width: screensizes.width / 1.0,
                  height: screensizes.height / 9.8,
                  child: new Form(
                    key: formKey,
                    child: new ScopedModelDescendant<GroupRestModel>(
                      rebuildOnChange: false,
                      builder: (context, child, model) {
                        return Card(
                          elevation: 8.0,
                          child: new Row(
                            children: <Widget>[
                              new SizedBox(
                                width: screensizes.width / 1.0 -
                                    screensizes.width / 7.0,
                                height: screensizes.height / 10.0,
                                child: new Padding(
                                  padding: new EdgeInsets.only(
                                      top: 0.0,
                                      left: 10.0,
                                      right: 1.0,
                                      bottom: 2.0),
                                  child: new Align(
                                    alignment: Alignment.bottomCenter,
                                    child: new InputTextFormField(
                                      texttype: TextInputType.text,
                                      hinttext: "Add new Group",
                                      iconType: new Icon(Icons.group),
                                      errorcheck: "Enter group name",
                                      onSave: (val) => newGroup = val,
                                    ),
                                  ),
                                ),
                              ),
                              new SizedBox(
                                width: screensizes.width / 10.0,
                                height: screensizes.height / 10.0,
                                child: new Padding(
                                  padding: new EdgeInsets.only(
                                    top: 0.0,
                                    bottom: 6.0,
                                  ),
                                  child: new Align(
                                    alignment: Alignment.bottomCenter,
                                    child: IconButton(
                                      color:
                                          new Color.fromRGBO(98, 0, 238, 0.5),
                                      icon: new Icon(Icons.add_circle),
                                      onPressed: () {
                                        _createGroup();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                new SizedBox(
                  width: screensizes.width / 1.0,
                  height: screensizes.height / 1.0 - screensizes.height / 4.8,
                  child: new ScopedModelDescendant<GroupRestModel>(
                    builder: (context, child, model) {
                      //
                      print(model.groupListCollection.length);
                      return model.groupListCollection.length != 0
                          ? new SizedBox(
                              width: screensizes.width / 1.0,
                              height: screensizes.height / 1.0 -
                                  screensizes.height / 8.0,
                              child: new Padding(
                                  padding: new EdgeInsets.only(
                                      top: 0.0, left: 5.0, right: 5.0),
                                  child: Align(
                                      alignment: Alignment.topCenter,
                                      child: ListView.builder(
                                        itemBuilder: (context, index) =>
                                            (ListItemGroups(
                                                listData: model
                                                    .groupListCollection[index],
                                                grouprestmodel:
                                                    grouprestmodel)),
                                        itemCount:
                                            model.groupListCollection.length,
                                      ))),
                            )
                          : new Center(child: new Icon(Icons.hourglass_empty));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
