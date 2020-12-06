import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:convertyoutubeplayer/Services/http_service.dart';
import 'package:convertyoutubeplayer/Services/token_service.dart';
import 'package:convertyoutubeplayer/requestPayloads/convertMp3/checkVideoStatusPayloadRequest.dart';
import 'package:convertyoutubeplayer/requestPayloads/requestDownload.dart';
import 'package:convertyoutubeplayer/urls.dart';
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
  CheckConvertPayloadRequest _lastResult;
  AudioPlayer audioPlayer = AudioPlayer();
  var _urlTxt = "https://www.youtube.com/watch?v=9vMLTcftlyI";
  var _msg = "";

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  void _startDownload() {
    if (!TokenService.instance.initiated) return;
    var tmp = StartConvertPayloadRequest(url: this._urlTxt, extension: "mp3");
    HttpService.instance.post(tmp.request).then((result) {
      if (!result.success) {
        print("(ERROR): Request failed");
        return;
      }
      print(
          "Request(${result.uuid}): title ${result.title}, status ${result.status}, percent ${result.percent}");
      setState(() {
        this._lastResult = result;
        this._msg = result.status;
      });
    });
  }

  void _checkIfNeeded() {
    if (this._lastResult != null &&
        (this._lastResult.status == "created" ||
            this._lastResult.status == "started" ||
            this._lastResult.status == "downloading" ||
            this._lastResult.status == "converting")) {
      print("Request not done");
      HttpService.instance.get(this._lastResult.request).then((result) {
        if (!result.success) {
          print("(ERROR): Request failed");
          return;
        }
        setState(() {
          this._lastResult = result;
          this._msg = result.status;
        });
        print(
            "Request(${result.uuid}): title ${result.title}, status ${result.status}, percent ${result.percent}");
      });
    }
  }

  void _checkIfCanDownloadFile() {
    if (this._lastResult == null || this._lastResult.status != "ended") return;
    print("Request done\nDownloading...");
    var tmp = RequestDownload(
      fileName: "test.mp3",
      url: this._lastResult.fileUrl,
      onProgress: (downloaded, sizeMax) {
        print("Download in progress ${downloaded / sizeMax * 100}%");
      },
      onDone: (file) async {
        await audioPlayer.play(file.path);
        this._lastResult = null;
      },
      onFail: () {
        this._lastResult = null;
      },
    );
    HttpService.instance.downloadFile(tmp).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    _checkIfNeeded();
    _checkIfCanDownloadFile();
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 0,
            width: 0,
            child: WebView(
              initialUrl: Urls.mp3ConvertUrlBrowser,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                TokenService.instance.setController(controller);
              },
              onPageFinished: (url) {
                TokenService.instance.init();
              },
            ),
          ),
          TextFormField(
            initialValue: this._urlTxt,
            onChanged: (str) {
              setState(() {
                this._urlTxt = str;
              });
            },
          ),
          Text(this._msg),
          FlatButton(
            child: Text("Télécharger"),
            onPressed: () async {
              _startDownload();
            },
          )
        ],
      ),
    );
  }
}
