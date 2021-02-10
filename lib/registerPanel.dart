import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:badminators/loginPanel.dart';
import 'package:http/http.dart' as http;

class registerPanel extends StatefulWidget {
  @override
  _registerPanelState createState() => _registerPanelState();
}

class _registerPanelState extends State<registerPanel> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passcontroller = TextEditingController();
  final TextEditingController _phcontroller = TextEditingController();

  String _email = "";
  String _pass = "";
  String _name = "";
  String _phone = "";
  bool _passwordVisible = false;
  bool _agreetoTandC = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        padding: EdgeInsets.all(30.0),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo.png',
                    scale: 3.5,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _namecontroller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.black),
                      icon: Icon(Icons.person, color: Colors.black),
                      errorStyle: TextStyle(fontSize: 14.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is Required !';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: _emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black),
                      icon: Icon(Icons.email, color: Colors.black),
                      errorStyle: TextStyle(fontSize: 14.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is Required !';
                      } else if (!validateEmail(value)) {
                        return 'Email is not valid !';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: _passcontroller,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black),
                      icon: Icon(Icons.lock, color: Colors.black),
                      errorStyle: TextStyle(fontSize: 14.0),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_passwordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is Required !';
                      } else if (!validatePassword(value)) {
                        return 'Password must be including letters, numbers !';
                      } else if (value.length < 6) {
                        return 'Password must be minimum 6 characters !';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: _phcontroller,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: TextStyle(color: Colors.black),
                      icon: Icon(Icons.phone, color: Colors.black),
                      errorStyle: TextStyle(fontSize: 14.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone Number is Required !';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        activeColor: Colors.black,
                        value: _agreetoTandC,
                        onChanged: (bool value) {
                          _onChange(value);
                        },
                      ),
                      Text(
                        'I agree to terms and conditions.',
                        style: TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    onPressed: _agreetoTandC ? _showRegisterDialog : null,
                    child: Text('Register',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onSurface: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 105, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      elevation: 15,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                      onTap: _onBackPress,
                      child: Text('Already Register',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRegister() async {
    _name = _namecontroller.text;
    _email = _emailcontroller.text;
    _pass = _passcontroller.text;
    _phone = _phcontroller.text;

    if (validateEmail(_email) && validatePassword(_pass) && _pass.length > 5) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(
          message: '   Registration...',
          borderRadius: 20.0,
          backgroundColor: Colors.black,
          progressWidget: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
              strokeWidth: 5.0),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          messageTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600));
      await pr.show();

      http.post("https://joshuaooigy.com/badminators/php/register_user.php",
          body: {
            "name": _name,
            "email": _email,
            "password": _pass,
            "phone": _phone,
          }).then((res) {
        print(res.body);
        if (res.body == "succes") {
          Toast.show(
            "Registration success. Please check your email to verify your account.",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
        } else {
          Toast.show(
            "Registration Failed.",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
        }
      }).catchError((err) {
        print(err);
      });
      await pr.hide();
    } else {
      Toast.show(
        "Invalid Email or Password",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
      );
      return;
    }
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool validatePassword(String value) {
    String pattern = r'^(?=.*?[a-z])(?=.*?[0-9])';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void _checkInput() {
    setState(() {
      if (_key.currentState.validate()) {
        print("Input is valid.");
      } else {
        print("Input is invalid.");
      }
    });
  }

  void _onBackPress() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => loginPanel()));
  }

  Future<bool> _showRegisterDialog() async {
    print('Backpress');

    Widget yesButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context).pop();
        _checkInput();
        _onRegister();
      },
    );

    Widget noButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Register an account?"),
      content: Text("Are you sure you want to register?"),
      actions: [
        yesButton,
        noButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    return Future.value(false);
  }

  void _onChange(bool value) {
    setState(() {
      _agreetoTandC = value;
    });
  }
}