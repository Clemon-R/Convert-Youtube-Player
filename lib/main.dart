import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebViewController _controller;

  Future<String> _getXsrfToken() async {
    final String cookies =
        await _controller.evaluateJavascript('document.cookie');
    RegExp exp = new RegExp(r"XSRF-TOKEN=([a-zA-Z0-9]+)");

    Iterable<Match> matches = exp.allMatches(cookies);
    if (matches == null) {
      print("No match");
      return null;
    } else {
      final matchedText = matches.elementAt(0).group(1);
      print("Token : " + matchedText);
      return matchedText;
    }
  }

  Future<String> _getToken() async {
    String html = await _controller.evaluateJavascript(
        "window.document.getElementsByTagName('html')[0].outerHTML;");
    RegExp exp = new RegExp(r"token\s=\s'([a-zA-Z0-9]+)'");

    Iterable<Match> matches = exp.allMatches(html);
    if (matches == null) {
      print("No match");
      return null;
    } else {
      final matchedText = matches.elementAt(0).group(1);
      print("Token : " + matchedText);
      return matchedText;
    }
  }

  void _test() async {
    var data = ConvertMp3RequestPayload(
        extension: "mp3", url: "https://www.youtube.com/watch?v=hhuvQGoGNWw");
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Token': await _getToken(),
      'X-XSFR-Token': await _getXsrfToken()
    };
    var dataJson = jsonEncode(data);
    print("Json: " + dataJson);
    var result = await http.post("https://mp3-youtube.download/download/start",
        headers: headers,
        body: jsonEncode(data),
        encoding: Encoding.getByName("utf-8"));
    print(result.body);
  }

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
              onWebViewCreated: (controller) => _controller = controller,
            ),
          ),
          FlatButton(
            child: Text("Hi"),
            onPressed: () {
              _test();
            },
          )
        ],
      ),
    );
  }
}

class ConvertMp3RequestPayload {
  final String url;
  final String extension;

  ConvertMp3RequestPayload({this.url, this.extension});

  ConvertMp3RequestPayload.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        extension = json['extension'];
  Map<String, dynamic> toJson() => {
        'url': url,
        'extension': extension,
      };
}
