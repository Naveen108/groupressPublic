import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:groupres/Components/input_text_form_field.dart';
import 'package:groupres/DataModels/user_model.dart';
import 'package:groupres/Screens/MenuScreen/index.dart';
import 'package:groupres/Screens/Register/index.dart';

class InvitedCode extends StatefulWidget {
  @override
  _InvitedCode createState() => new _InvitedCode();
}

class _InvitedCode extends State<InvitedCode> {
  final UserModel usermodel = UserModel();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String _groupid;
  String _phonenumberid;
  String _name;
  Future _performLogin() async {
    await usermodel.inviteCheck(_phonenumberid, _groupid, _name).then((data) {
      print('data in inviteCheck = $data');
      if (data == true) {
        UserModel.userPhoneNumber = _phonenumberid;
        UserModel.currentGroup = _groupid;
        UserModel.username = _name;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MenuScreen()));
      } else {
        final snackbar =
            SnackBar(content: new Text('Wrong Username Or Group name'));
        scaffoldKey.currentState.showSnackBar(snackbar);
      }
    });
  }

  void _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      _performLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
      // appBar: AppBar(
      //   title: const Text('Check Your Invitation'),
      //   backgroundColor: Colors.blueGrey,
      // ),
      body: Container(
          decoration: new BoxDecoration(
            color: Colors.white12,
            image: new DecorationImage(
              fit: BoxFit.fill,
              //fit: BoxFit.scaleDown,
              image: new ExactAssetImage("assets/invitecode.jpg"),
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              //image: new ExactAssetImage('assets/SplashIcon.png'),
            ),
          ),
          child: ListView(children: [
            // Image.asset(
            //   'assets/vegfood.jpg',
            // ),
            new Padding(
                padding:
                    new EdgeInsets.only(top: 85.0, left: 80.0, right: 80.0),
                child: new Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/groupinvite2.png',
                  ),
                )),
            new Padding(
              padding: new EdgeInsets.only(
                top: 30.0,
                bottom: 10.0,
              ),
              child: new Text(
                'Check Your Invitation!',
                textAlign: TextAlign.center,
                style: new TextStyle(
                    fontSize: 25.0, color: Colors.blueGrey.withOpacity(0.9)),
              ),
            ),
            new Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    new Padding(
                        padding: new EdgeInsets.only(
                            top: 15.0, left: 0.0, right: 0.0),
                        child: new Align(
                          alignment: Alignment.bottomCenter,
                          child: new InputTextFormField(
                            texttype: TextInputType.url,
                            hinttext: "Group Name",
                            iconType: new Icon(Icons.group_work),
                            errortext: "Enter group name",
                            errorcheck: "",
                            onSave: (val) => _groupid = val,
                          ),
                        )),
                    new Padding(
                        padding: new EdgeInsets.only(
                            top: 15.0, left: 0.0, right: 0.0),
                        child: new Align(
                          alignment: Alignment.bottomCenter,
                          child: new InputTextFormField(
                            texttype: TextInputType.url,
                            hinttext: "Username ",
                            iconType: new Icon(Icons.person),
                            errortext: "Enter Your  Name",
                            errorcheck: "",
                            onSave: (val) => _name = val,
                          ),
                        )),
                    new Padding(
                        padding: new EdgeInsets.only(
                            top: 15.0, left: 0.0, right: 0.0),
                        child: new Align(
                          alignment: Alignment.bottomCenter,
                          child: new InputTextFormField(
                            texttype: TextInputType.phone,
                            hinttext: "Your Phone number",
                            iconType: new Icon(Icons.person),
                            errortext: "Enter Your Phone number",
                            errorcheck: "",
                            onSave: (val) => _phonenumberid = val,
                          ),
                        )),
                    new Padding(
                        padding: new EdgeInsets.only(
                          top: 30.0,
                        ),
                        child: new Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: screensize.width / 1.0,
                            height: screensize.height / 11.0,
                            child: RaisedButton(
                              onPressed: _submit,
                              child: new Text(
                                'Let\'s Join Group',
                                style: new TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black87.withOpacity(0.9)),
                              ),
                              color: new Color.fromRGBO(98, 0, 238, 0.4),
                            ),
                          ),
                          // new Icon(Icons.vpn_key), "Enter password", ""),
                        )),
                    new Padding(
                      padding: new EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new InkWell(
                            child: new Text(
                              'SignUp?',
                              style: new TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.blueGrey.withOpacity(0.9)),
                            ),
                            onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Register(),
                                  ),
                                ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ])),
      //
    );
  }
}
