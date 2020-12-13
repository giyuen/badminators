import 'package:badminators/registerPanel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class loginPanel extends StatefulWidget {
  @override
  _loginPanelState createState() => _loginPanelState();
}

class _loginPanelState extends State<loginPanel> {
  final TextEditingController _emailcontroller = TextEditingController();
  String _email = "";
  final TextEditingController _passcontroller = TextEditingController();
  String _pass = "";
  bool _rememberMe = false;

  @override
  void initState() {
    loadpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: _showExitDialog,
        child: Container(
          padding: EdgeInsets.all(30.0),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/logo.png',
                      scale: 3,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: _emailcontroller,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.black),
                            icon: Icon(Icons.email, color: Colors.black))),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _passcontroller,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black),
                        icon: Icon(Icons.lock, color: Colors.black),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: _onForgot,
                        child: Text('Forgot password ?',
                            style: TextStyle(fontSize: 16))),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 300,
                      height: 50,
                      child: Text('Login', style: TextStyle(fontSize: 15)),
                      color: Colors.black,
                      textColor: Colors.white,
                      elevation: 15,
                      onPressed: _onLogin,
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          activeColor: Colors.black,
                          value: _rememberMe,
                          onChanged: (bool value) {
                            _onChange(value);
                          },
                        ),
                        Text(
                          'Remember Me',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 300,
                      height: 50,
                      child: Text('Create Account',
                          style: TextStyle(fontSize: 15)),
                      color: Colors.white,
                      textColor: Colors.black,
                      elevation: 15,
                      onPressed: _onRegister,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onLogin() {}

  void _onRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => registerPanel()));
  }

  void _onForgot() {}

  void _onChange(bool value) {
    setState(() {
      _rememberMe = value;
      savepref(value);
    });
  }

  void loadpref() async {
    print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email'));
    _pass = (prefs.getString('pass'));
    if (_email != '' && _pass != '') {
      print('loading');
      _emailcontroller.text = _email;
      _passcontroller.text = _pass;
      setState(() {
        _rememberMe = true;
      });
    } else {
      print('No pref');
      setState(() {
        _rememberMe = false;
      });
    }
  }

  void savepref(bool value) async {
    _email = _emailcontroller.text;
    _pass = _passcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      if (_isEmailValid(_email) && _pass.length > 5) {
        await prefs.setString('email', _email);
        await prefs.setString('pass', _pass);
        print('Save pref $_email');
        print('Save pref $_pass');
        Toast.show("Preferences saved succesfully", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        print('Invalid Email or Password.');
        setState(() {
          _rememberMe = false;
        });
        Toast.show("Incorrect username or password.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailcontroller.text = '';
        _passcontroller.text = '';
        _rememberMe = false;
      });
      print('Remove pref');
      Toast.show("Preferences removed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  Future<bool> _showExitDialog() async {
    print('Backpress');
    Widget noButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget yesButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        SystemNavigator.pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Confrim Exit?"),
      content: Text("Are you sure you want to exit?"),
      actions: [
        noButton,
        yesButton,
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
}
