import 'dart:convert';
import 'dart:io';

import 'package:convertyoutubeplayer/Services/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'config.dart';

void main() {
  Config.initServices();
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
  TokenService _tokenService = Config.getIt<TokenService>();

  void _test() async {
    var data = ConvertMp3RequestPayload(
        extension: "mp3", url: "https://www.youtube.com/watch?v=hhuvQGoGNWw");
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Token': _tokenService.token,
      'X-XSFR-Token': _tokenService.xsrfToken
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
              onWebViewCreated: (controller) {
                _tokenService.init(controller);
              },
            ),
          ),
          FlatButton(
            child: Text("Cheng BG = Romain"),
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
