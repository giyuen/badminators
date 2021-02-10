import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:badminators/loginPanel.dart';

class mainDrawer extends StatefulWidget {
  @override
  _mainDrawerState createState() => _mainDrawerState();
}

class _mainDrawerState extends State<mainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          accountName: Text("Ooi Gi Yuen"),
          accountEmail: Text("*******@gmail.com"),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              "O",
              style: TextStyle(fontSize: 40.0, color: Colors.black),
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.security_rounded),
          title: Text('Reset Password'),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  elevation: 16,
                  child: Container(
                    height: 400.0,
                    width: 360.0,
                    child: ListView(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            "Reset Password",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30,20,30,10),
                          child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: 'Current Password',
                                  labelStyle: TextStyle(color: Colors.black),
                                  icon:
                                      Icon(Icons.lock, color: Colors.black))),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30,0,30,10),
                          child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: 'New Password',
                                  labelStyle: TextStyle(color: Colors.black),
                                  icon:
                                      Icon(Icons.lock, color: Colors.black))),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30,0,30,40),
                          child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: 'Re-type new Password',
                                  labelStyle: TextStyle(color: Colors.black),
                                  icon:
                                      Icon(Icons.lock, color: Colors.black))),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(50,0,50,10),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            minWidth: 250,
                            height: 50,
                            child: Text('Save Changes',
                                style: TextStyle(fontSize: 15)),
                            color: Colors.black,
                            textColor: Colors.white,
                            elevation: 15,
                            onPressed: () {
                              Navigator.of(context).pop();
                              Toast.show(
                                  "New Password had successfully saved.",
                                  context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Log Out'),
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => loginPanel()));
          },
        ),
      ],
    ));
  }
}
