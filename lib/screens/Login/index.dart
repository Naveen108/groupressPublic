import 'package:flutter/services.dart';
import 'package:groupres/Components/input_phone_form_field.dart';
import 'package:groupres/Screens/InvitedCode/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:groupres/Components/input_pass_form_field.dart';
import 'package:groupres/DataModels/user_model.dart';
import 'package:groupres/DataModels/user_class.dart';
import 'package:groupres/Screens/Register/index.dart';
import 'package:groupres/Screens/MenuScreen/index.dart';

class LoginPage extends StatefulWidget {
  //initializing Model of Screen USerloginpage
  final UserModel model = new UserModel();
  @override
  _LoginPage createState() => new _LoginPage(model: model);
}

class _LoginPage extends State<LoginPage> {
  final UserModel model;
  _LoginPage({this.model});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  String _phonenumber;
  String _password;

  void _performLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    User user = new User(phonenumber: _phonenumber, password: _password);
    model.loginCheck(user).then((data) async {
      print("data in login check= $data");
      if (data == true) {
        await prefs.setString('userphone', _phonenumber).then((data) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MenuScreen()));
        });
      } else {
        final snackbar = SnackBar(
          content: Text('Wrong Credentials'),
        );

        scaffoldKey.currentState.showSnackBar(snackbar);
      }
    });
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      _performLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,

      body: Container(
        decoration: new BoxDecoration(
          color: Colors.blueGrey[50],
          image: new DecorationImage(
            fit: BoxFit.fill,
            image: new ExactAssetImage("assets/vegfood2.jpg"),
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
          ),
        ),
        child: ListView(
          children: [
            new Padding(
              padding: new EdgeInsets.only(top: 150.0, left: 80.0, right: 80.0),
              child: new Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/LoginMe.png',
                ),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.only(
                top: 30.0,
                bottom: 10.0,
              ),
              child: new Text(
                'Login!',
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
                        top: 30.0,
                        bottom: 10.0,
                      ),
                      child: new InputPhoneFormField(
                        texttype: TextInputType.phone,
                        hinttext: "Phone number",
                        iconType: new Icon(Icons.email),
                        errortext: "Enter correct number",
                        errorcheck: "",
                        onSave: (val) => _phonenumber = val,
                      ),
                    ),
                    new InputPassFormField(
                      texttype: TextInputType.url,
                      hinttext: "password",
                      iconType: new Icon(Icons.vpn_key),
                      errortext: "Enter password",
                      errorcheck: "",
                      onSave: (val) => _password = val,
                    ),
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
                                'Sign in',
                                style: new TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black.withOpacity(0.9)),
                              ),
                              color: new Color.fromRGBO(98, 0, 238, 0.4),
                              //.purple[200],
                            ),
                          ),
                        )),
                    new Padding(
                      padding: new EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Padding(
                            padding: new EdgeInsets.only(
                              top: 1.0,
                              bottom: 5.0,
                            ),
                            child: new InkWell(
                              child: new Text(
                                'Don\'t have an account?Sign Up',
                                style: new TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.blueGrey.withOpacity(0.9)),
                              ),
                              onTap: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Register(model: model),
                                    ),
                                  ),
                            ),
                          ),
                          new Padding(
                            padding: new EdgeInsets.only(
                              top: 2.0,
                              bottom: 5.0,
                            ),
                            child: new InkWell(
                              child: new Text(
                                'Got Invite?',
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.blueGrey.withOpacity(0.9)),
                              ),
                              onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InvitedCode(),
                                    ),
                                  ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
      //
    );
  }
}
