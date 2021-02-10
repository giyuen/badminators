import 'dart:convert';
import 'package:badminators/badmintonsessionPanel.dart';
import 'package:badminators/clubs.dart';
import 'package:badminators/mainDrawer.dart';
import 'package:badminators/checkoutPanel.dart';
import 'package:badminators/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';

class mainPanel extends StatefulWidget {
  final User user;

  const mainPanel({Key key, this.user}) : super(key: key);
  @override
  _mainPanelState createState() => _mainPanelState();
}

class _mainPanelState extends State<mainPanel> {
  List clubslist;
  String titlecenter = "No Clubs Available.";

  double screenHeight, screenWidth;
  @override
  void initState() {
    super.initState();
    _loadClubs();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.jpg"),
                    fit: BoxFit.cover)),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: Text(
                    'Badminton Club Available',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.exit_to_app_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    checkoutPanel(
                                      user: widget.user,
                                    )));
                      },
                    ),
                  ],
                  backgroundColor: Colors.black,
                ),
                drawer: mainDrawer(),
                body: Container(
                    padding: EdgeInsets.all(30.0),
                    child: Column(children: [
                      clubslist == null
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
                                      (screenWidth / screenHeight) / 0.52,
                                  children:
                                      List.generate(clubslist.length, (index) {
                                    return Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 5, 10, 5),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          color: Colors.white70,
                                          elevation: 10,
                                          child: InkWell(
                                              onTap: () =>
                                                  _loadclubDetail(index),
                                              child: Column(children: [
                                                Container(
                                                  height: screenHeight / 3.85,
                                                  width: screenWidth / 1.8,
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "https://joshuaooigy.com/badminators/BadmintonClubImages/${clubslist[index]['clubimage']}.jpg",
                                                    fit: BoxFit.scaleDown,
                                                    placeholder: (context,
                                                            url) =>
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
                                                            clubslist[index]
                                                                ['clubname'],
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        softWrap: true,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(Icons.pin_drop_rounded,
                                                        color: Colors.blue),
                                                    Flexible(
                                                      child: Text(
                                                        ' ' +
                                                            clubslist[index]
                                                                ['clubstate'],
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(Icons.phone,
                                                        color: Colors.black),
                                                    Text(
                                                      ' ' +
                                                          clubslist[index]
                                                              ['clubphone'],
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ])),
                                        ));
                                  })),
                            ),
                    ])))));
  }

  Future<void> _loadClubs() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();

    http.post("https://joshuaooigy.com/badminators/php/load_badmintonClub.php",
        body: {}).then((club) {
      print(club.body);
      if (club.body == "nodata") {
        clubslist = null;
      } else {
        setState(() {
          var jsondata = json.decode(club.body);
          clubslist = jsondata["club"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadclubDetail(int index) {
    print(clubslist[index]['clubname']);
    Clubs clubs = new Clubs(
      clubid: clubslist[index]['clubid'],
      clubname: clubslist[index]['clubname'],
      clubphone: clubslist[index]['clubphone'],
      clubstate: clubslist[index]['clubstate'],
      clubimage: clubslist[index]['clubimage'],
    );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => badmintonsessionPanel(
                  clubs: clubs,
                  user: widget.user,
                )));
  }
}
