import 'dart:convert';
import 'package:badminators/billPanel.dart';
import 'package:badminators/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class checkoutPanel extends StatefulWidget {
  final User user;

  const checkoutPanel({Key key, this.user}) : super(key: key);

  @override
  _checkoutPanelState createState() => _checkoutPanelState();
}

class _checkoutPanelState extends State<checkoutPanel> {
  List savedsessionslist;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Saved Sessions...";
  double totalPrice = 0.0;
  final formatter = new NumberFormat("#,##");
  int numSavedsessions = 0;

  @override
  void initState() {
    super.initState();
    _loadSavedSession();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Check Out',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.black,
            ),
            body: Container(
              padding: EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/background.jpg"),
                      fit: BoxFit.cover)),
              child: Column(children: [
                savedsessionslist == null
                    ? Flexible(
                        child: Container(
                            child: Center(
                                child: Text(
                        titlecenter,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ))))
                    : Flexible(
                        child: GridView.count(
                            crossAxisCount: 1,
                            childAspectRatio:
                                (screenWidth / screenHeight) / 0.78,
                            children: List.generate(savedsessionslist.length,
                                (index) {
                              return Padding(
                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Colors.white70,
                                    elevation: 10,
                                    child: InkWell(
                                        onLongPress: () =>
                                            _deleteSessionDialog(index),
                                        child: Column(children: [
                                          Container(
                                            height: screenHeight / 3.85,
                                            width: screenWidth / 1.8,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://joshuaooigy.com/badminators/BadmintonClubImages/${savedsessionslist[index]['sessionimage']}.jpg",
                                              fit: BoxFit.scaleDown,
                                              placeholder: (context, url) =>
                                                  new CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      new Icon(
                                                Icons.broken_image,
                                                size: screenWidth / 2,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.book,
                                                  color: Colors.black),
                                              Flexible(
                                                child: Text(
                                                  ' ' +
                                                      savedsessionslist[index]
                                                          ['clubname'],
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Flexible(
                                                child: Text(
                                                  ' ' +
                                                      savedsessionslist[index]
                                                          ['sessionname'],
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.money,
                                                  color: Colors.black),
                                              Flexible(
                                                child: Text(
                                                  ' RM' +
                                                      savedsessionslist[index]
                                                          ['sessionprice'] +
                                                      " /Session",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.pin_drop_rounded,
                                                  color: Colors.black),
                                              Text(
                                                ' Location : ',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Flexible(
                                                child: Text(
                                                  savedsessionslist[index]
                                                      ['sessionlocation'],
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ])),
                                  ));
                            })),
                      ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: screenHeight / 5,
                    width: screenWidth / 0.3,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.black,
                      elevation: 10,
                      child: Column(children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                            "Total Amount : RM" + totalPrice.toStringAsFixed(2),
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minWidth: 300,
                          height: 50,
                          child: Text('Make Payment',
                              style: TextStyle(fontSize: 15)),
                          color: Colors.white,
                          textColor: Colors.black,
                          elevation: 15,
                          onPressed: _onPaymentDialog,
                        ),
                      ]),
                    )),
              ]),
            )));
  }

  void _loadSavedSession() {
    http.post("https://joshuaooigy.com/badminators/php/load_savedsession.php",
        body: {
          "email": widget.user.email,
        }).then((club) {
      print(club.body);
      if (club.body == "nodata") {
        savedsessionslist = null;
        setState(() {
          titlecenter = "No Session Found.";
        });
      } else {
        totalPrice = 0;
        numSavedsessions = 0;
        setState(() {
          var jsondata = json.decode(club.body);
          savedsessionslist = jsondata["savedsessions"];
          for (int i = 0; i < savedsessionslist.length; i++) {
            totalPrice = totalPrice +
                double.parse(savedsessionslist[i]['sessionprice']) *
                    int.parse(savedsessionslist[i]['sessionplace']);
            numSavedsessions = numSavedsessions +
                int.parse(savedsessionslist[i]['sessionplace']);
          }
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deleteSessionDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete this session ?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are your sure? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _deleteSession(index);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteSession(int index) {
    http.post("https://joshuaooigy.com/badminators/php/delete_savedsession.php",
        body: {
          "email": widget.user.email,
          "sessionid": savedsessionslist[index]['sessionid'],
        }).then((club) {
      print(club.body);
      if (club.body == "success") {
        totalPrice=0;
        _loadSavedSession();
        Toast.show(
          "The selected session had successfully deleted.",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
      } else {
        Toast.show(
          "Delete failed.",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _onPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Proceed with payment?',
          style: TextStyle(
              //color: Colors.white,
              ),
        ),
        content: new Text(
          'Are you sure to pay RM' + totalPrice.toStringAsFixed(2) + "?",
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _makePayment();
              },
              child: Text(
                "Ok",
                style: TextStyle(
                    //color: Color.fromRGBO(101, 255, 218, 50),
                    ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
              )),
        ],
      ),
    );
  }

  Future<void> _makePayment() async {
  await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => billPanel(
                  user: widget.user,
                  totalAmount: totalPrice.toStringAsFixed(2),
                )));
                totalPrice=0;
    _loadSavedSession();
  }
}
