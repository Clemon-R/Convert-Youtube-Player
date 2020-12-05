import 'dart:io';

import 'package:convertyoutubeplayer/Services/http_service.dart';
import 'package:convertyoutubeplayer/Services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'requestPayloads/convertMp3/startConvertPayloadRequest.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Convert Youtube Player',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(title: 'Login'),
        });
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _startRequest = StartConvertPayloadRequest(
      "https://www.youtube.com/watch?v=9vMLTcftlyI", "mp3");

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 0,
            width: 0,
            child: WebView(
              initialUrl:
                  'https://mp3-youtube.download/fr/your-audio-converter',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                TokenService.instance.setController(controller);
              },
              onPageFinished: (url) {
                TokenService.instance.init();
              },
            ),
          ),
          FlatButton(
            child: Text("Livreur colis KDO"),
            onPressed: () async {
              //_test();
              var result =
                  await HttpService.instance.post(_startRequest.request);
              print("Request(" + result.uuid + "): status " + result.status);
            },
          )
        ],
      ),
    );
  }
}
