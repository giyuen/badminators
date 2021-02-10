import 'dart:convert';
import 'package:badminators/clubs.dart';
import 'package:badminators/checkoutPanel.dart';
import 'package:badminators/sessionDetailPanel.dart';
import 'package:badminators/sessions.dart';
import 'package:badminators/user.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

class badmintonsessionPanel extends StatefulWidget {
  final Clubs clubs;
  final User user;

  const badmintonsessionPanel({Key key, this.clubs, this.user})
      : super(key: key);

  @override
  _badmintonsessionPanelState createState() => _badmintonsessionPanelState();
}

class _badmintonsessionPanelState extends State<badmintonsessionPanel> {
  List sessionslist;
  String titlecenter = "Loading Badminton Sessions...";
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                widget.clubs.clubname,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
            builder: (BuildContext context) => checkoutPanel(
             user: widget.user,
             )));
      },
    )
  ],
              backgroundColor: Colors.black,
            ),
            body: Container(
              padding: EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/background.jpg"),
                      fit: BoxFit.cover)),
              child: Column(children: [
                Container(
                  height: screenHeight / 3.85,
                  width: screenWidth / 1.8,
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://joshuaooigy.com/badminators/BadmintonClubImages/${widget.clubs.clubimage}.jpg",
                    fit: BoxFit.scaleDown,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(
                      Icons.broken_image,
                      size: screenWidth / 2,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                sessionslist == null
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
                                (screenWidth / screenHeight) / 0.165,
                            children:
                                List.generate(sessionslist.length, (index) {
                              return Padding(
                                  padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Colors.black,
                                    elevation: 10,
                                    child: InkWell(
                                        onTap: () => _loadSessionDetails(index),
                                        child: Column(children: [
                                          SizedBox(
                                            height: 25,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Flexible(
                                                child: Text(
                                                  ' ' +
                                                      sessionslist[index]
                                                          ['sessionname'],
                                                  style: TextStyle(
                                                      color: Colors.white,
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
                                        ])),
                                  ));
                            })),
                      ),
              ]),
            )));
  }

  Future<void> _loadSessions() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    http.post("https://joshuaooigy.com/badminators/php/load_sessions.php",
        body: {
          "clubid": widget.clubs.clubid,
        }).then((club) {
      print(club.body);
      if (club.body == "nodata") {
        sessionslist = null;
        setState(() {
          titlecenter = "No Badminton Session Available";
        });
      } else {
        setState(() {
          var jsondata = json.decode(club.body);
          sessionslist = jsondata["sessions"];
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  _loadSessionDetails(int index) {
    Sessions sessions = new Sessions(
        sessionid: sessionslist[index]['sessionid'],
        sessionname: sessionslist[index]['sessionname'],
        sessionprice: sessionslist[index]['sessionprice'],
        sessionlocation: sessionslist[index]['sessionlocation'],
        remainingplace: sessionslist[index]['remainingplace'],
        clubid: widget.clubs.clubid);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => sessionDetailPanel(
                  sessions: sessions,
                  user: widget.user,
                  clubs: widget.clubs,
                )));
  }
}
