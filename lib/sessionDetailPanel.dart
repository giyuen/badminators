import 'package:badminators/clubs.dart';
import 'package:badminators/sessions.dart';
import 'package:badminators/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class sessionDetailPanel extends StatefulWidget {
  final Sessions sessions;
  final User user;
  final Clubs clubs;
  const sessionDetailPanel({Key key, this.sessions, this.user, this.clubs})
      : super(key: key);

  @override
  _sessionDetailPanelState createState() => _sessionDetailPanelState();
}

class _sessionDetailPanelState extends State<sessionDetailPanel> {
  double screenHeight, screenWidth;
    int sessionplace = 1;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Session Details",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.black,
            ),
            body: Center(
                child: SingleChildScrollView(
                    child: Container(
              padding: EdgeInsets.fromLTRB(25, 30, 25, 35),
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
                  height: 30,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.white70,
                  elevation: 10,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.confirmation_number, color: Colors.black),
                          Text(
                            ' Session ID : ' + widget.sessions.sessionid,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.book, color: Colors.black),
                          Text(
                            '  ' + widget.sessions.sessionname,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.money, color: Colors.black),
                          Text(
                            ' Price: RM' +
                                widget.sessions.sessionprice +
                                " /Session",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.pin_drop_rounded, color: Colors.black),
                          Text(
                            ' Location : ',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              widget.sessions.sessionlocation,
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.event_seat_rounded, color: Colors.black),
                          Text(
                            ' Remaining Place : ' +
                                widget.sessions.remainingplace,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 180,
                  height: 50,
                  child: Text('Attend', style: TextStyle(fontSize: 15)),
                  color: Colors.black,
                  textColor: Colors.white,
                  elevation: 15,
                  onPressed: _onAttendDialog,
                ),
              ]),
            )))));
  }

  void _onAttendDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Attend this session ? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure ?",
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
              onPressed: () {
                Navigator.of(context).pop();
                _attendSession();
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

  void _attendSession() {
    http.post("https://joshuaooigy.com/badminators/php/insert_attend.php", body: {
      "email": widget.user.email,
      "sessionid": widget.sessions.sessionid,
      "sessionplace": sessionplace.toString(),
      "clubid": widget.clubs.clubid,
    }).then((club) {
      print(club.body);
      if (club.body == "success") {
        Toast.show(
          "Successfully saved. Please press the Check Out Icon above to proceed payment.",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        Navigator.pop(context);
      } else {
        Toast.show(
          "Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }
}
