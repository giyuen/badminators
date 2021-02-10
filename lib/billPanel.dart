import 'dart:async';
import 'package:badminators/user.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
 
 
class billPanel extends StatefulWidget {
  final User user;
   final String totalAmount;

  const billPanel({Key key, this.user, this.totalAmount}) : super(key: key);

  @override
  _billPanelState createState() => _billPanelState();
}

class _billPanelState extends State<billPanel> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Bill'),
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl:
                    'https://joshuaooigy.com/badminators/php/generate_bill.php?email=' +
                        widget.user.email +
                        '&mobile=' +
                        widget.user.phone +
                        '&name=' +
                        widget.user.name +
                        '&amount=' +
                        widget.totalAmount,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )
                      ],
                    ));
              }
            
            
}