import 'package:flutter/material.dart';
import 'package:groupres/Components/list_item_friends.dart';
import 'package:groupres/Components/custom_drawer.dart';
import 'package:groupres/Components/input_phone_form_field.dart';
import 'package:groupres/DataModels/group_rest_model.dart';
import 'package:groupres/DataModels/user_model.dart';
import 'package:groupres/Screens/creategroup/index.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:groupres/DataModels/invite_new_friend_class.dart';

class InviteFriend extends StatefulWidget {
  @override
  _InviteFriend createState() => new _InviteFriend();
}

class _InviteFriend extends State<InviteFriend> {
  final GroupRestModel grouprestmodel = GroupRestModel();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final index = 3;
  String newFriendcontact;
  String user = UserModel.userPhoneNumber;
  String group = UserModel.currentGroup != '' ? UserModel.currentGroup : '';
  void _inviteFriend() {
    print('Called me to add new F ');
    if (group != 'GR' && group != '') {
      if (formKey.currentState.validate()) {
        formKey.currentState.save();

        InviteNewFriend newFriend = InviteNewFriend();
        newFriend.byUser = user;
        newFriend.groupId = UserModel.groupId;
        newFriend.friendNumber = newFriendcontact;
        if (newFriendcontact.length != 0) {
          formKey.currentState.reset();
          grouprestmodel.inviteFriend(newFriend).then((data) {
            String snackbarText;
            if (data == true) {
              snackbarText = 'Added Friend With Name $newFriendcontact';
            } else {
              snackbarText =
                  'Couldn\'t Add New Friend:- $newFriendcontact Or Already Added';
            }
            final snackbar = SnackBar(
              content: Text(snackbarText),
            );
            scaffoldKey.currentState.showSnackBar(snackbar);
          });
        }
      } else {
        String snackbarText = 'Enter Correct Friend\'s Number ';
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
    grouprestmodel.fetchFriendItems(UserModel.groupId);
    return ScopedModel<GroupRestModel>(
      model: grouprestmodel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Menu',
        home: Scaffold(
          drawer: new CustomDrawer(index: index
              //cartmodel: cartmodel,
              ),
          key: scaffoldKey,
          appBar: AppBar(
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.group_work),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => CreateGroup()));
                },
              ),
            ],
            title: new Text(UserModel.currentGroup +
                '\'s FriendList '), //+ UserModel.currentGroup
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
                                    child: new InputPhoneFormField(
                                      texttype: TextInputType.url,
                                      hinttext: "Add a friend in Group",
                                      iconType: new Icon(Icons.person_add),
                                      errortext: "Enter Your Friend's Number ",
                                      onSave: (val) => newFriendcontact = val,
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
                                        _inviteFriend();
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
                      print(model.friendListCollection.length);
                      return model.friendListCollection.length != 0
                          ? ListView.builder(
                              itemBuilder: (context, index) => (ListItemFriends(
                                    listData: model.friendListCollection[index],
                                  )),
                              itemCount: model.friendListCollection.length,
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
