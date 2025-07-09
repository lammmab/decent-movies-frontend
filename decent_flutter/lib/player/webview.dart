import 'package:flutter/material.dart';
import 'package:webview_all/webview_all.dart';

class MyBrowser extends StatefulWidget {
  const MyBrowser({Key? key, this.title}) : super(key: key);
  final String? title;
  
  @override
  _MyBrowserState createState() => _MyBrowserState();
}

class _MyBrowserState extends State<MyBrowser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title ?? 'Player')),
        body: Center(
          child: Webview(url: "https://www.wechat.com/en")
      )
    );
  }
}