//Register Page
import 'package:flutter/material.dart';
import 'package:groupres/Components/input_text_form_field.dart';
import 'package:groupres/Components/input_pass_form_field.dart';
import 'package:groupres/Components/input_phone_form_field.dart';
import 'package:groupres/DataModels/user_model.dart';
import 'package:groupres/DataModels/new_user_register_class.dart';
import 'package:groupres/Screens/InvitedCode/index.dart';
import 'package:groupres/Screens/Login/index.dart';
import 'package:groupres/Screens/MenuScreen/index.dart';

class Register extends StatefulWidget {
  final UserModel model;
  Register({this.model});
  @override
  _Register createState() => new _Register(model: model);
}

class _Register extends State<Register> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  final UserModel model;
  _Register({this.model});
  String _userName;
  String _password;
  String _phonenumber;

  void _perfomSingUp() {
    //call function to create a new Group
    NewUserRegister newUser = NewUserRegister(
        userName: _userName, password: _password, phoneNumber: _phonenumber);
    model.singUp(newUser).then((data) {
      print(data);
      if (data != false) {
        UserModel.username = _userName;
        UserModel.userPhoneNumber = _phonenumber;
        UserModel.currentGroup = 'GR';
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MenuScreen()));
      } else {
        final snackbar = SnackBar(
          //show When login true else non
          content: Text('Registratrion failed'),
        );

        scaffoldKey.currentState.showSnackBar(snackbar);
      }
    });
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      _perfomSingUp();
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
              image: new ExactAssetImage("assets/res2.jpg"),
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
            ),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new Padding(
                    padding:
                        new EdgeInsets.only(top: 15.0, left: 80.0, right: 80.0),
                    child: new Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        'assets/loginnew.png',
                      ),
                    )),
                new Padding(
                  padding: new EdgeInsets.only(
                    top: 30.0,
                    bottom: 10.0,
                  ),
                  child: new Text(
                    'Sign Up!',
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 25.0,
                        color: Colors.blueGrey.withOpacity(0.9)),
                  ),
                ),
                new Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        new Padding(
                            padding: new EdgeInsets.only(
                                top: 10.0, left: 0.0, right: 0.0),
                            child: new Align(
                              alignment: Alignment.bottomCenter,
                              child: new InputTextFormField(
                                texttype: TextInputType.text,
                                hinttext: "Your Name",
                                iconType: new Icon(Icons.person),
                                errortext: "Enter name here",
                                errorcheck: "",
                                onSave: (val) => _userName = val,
                              ),
                            )),
                        new Padding(
                            padding: new EdgeInsets.only(
                                top: 15.0, left: 0.0, right: 0.0),
                            child: new Align(
                              alignment: Alignment.bottomCenter,
                              child: new InputPhoneFormField(
                                texttype: TextInputType.phone,
                                hinttext: "Phone number",
                                iconType: new Icon(Icons.phone),
                                errortext: "Enter correct Number",
                                errorcheck: "",
                                onSave: (val) => _phonenumber = val,
                              ),
                            )),
                        new Padding(
                            padding: new EdgeInsets.only(
                                top: 15.0, left: 0.0, right: 0.0),
                            child: new Align(
                              alignment: Alignment.bottomCenter,
                              child: new InputPassFormField(
                                texttype: TextInputType.text,
                                hinttext: "Password",
                                iconType: new Icon(Icons.vpn_key),
                                errortext: "Enter password",
                                errorcheck: "",
                                onSave: (val) => _password = val,
                              ),
                            )),
                        new Padding(
                          padding: new EdgeInsets.only(
                            top: 15.0,
                          ),
                          child: new Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: screensize.width / 1.0,
                              height: screensize.height / 11.0,
                              child: RaisedButton(
                                onPressed: _submit,
                                child: new Text(
                                  'Sign Up',
                                  style: new TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black87.withOpacity(0.9)),
                                ),
                                color: new Color.fromRGBO(98, 0, 238, 0.4),
                              ),
                            ),
                          ),
                        ),
                        new Padding(
                          padding: new EdgeInsets.only(
                            top: 10.0,
                            bottom: 37.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new InkWell(
                                child: new Text(
                                  'Already User?',
                                  style: new TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.blueGrey.withOpacity(0.9)),
                                ),
                                onTap: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage())),
                              ),
                              new InkWell(
                                child: new Text(
                                  'Got Invite?',
                                  style: new TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.blueGrey.withOpacity(0.9)),
                                ),
                                onTap: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InvitedCode())),
                              )
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
