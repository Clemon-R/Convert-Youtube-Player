import 'dart:async';
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
  RequestDownload _lastDownload;
  final _audioPlayer = AudioPlayer();
  final _textController = TextEditingController();
  WebViewController _webViewController;
  Timer _refreshTimer;

  var _urlTxt = Urls.youtube;
  var _msg = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    const halfSecond = const Duration(milliseconds: 500);
    this._refreshTimer = new Timer.periodic(halfSecond, (Timer t) async {
      if (this._webViewController == null) return;
      this._urlTxt = await this._webViewController.currentUrl();
      this._textController.text = this._urlTxt;
    });
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
    if (this._lastDownload != null || this._lastResult == null || this._lastResult.status != "ended") return;
    print("Request done\nDownloading...");
    _lastDownload = RequestDownload(
      fileName: this._lastResult.title,
      url: this._lastResult.fileUrl,
      onProgress: (downloaded, sizeMax) {
        print("Download in progress ${downloaded / sizeMax * 100}%");
        setState(() {
          this._msg = "download";
        });
      },
      onDone: (file) async {
        await _audioPlayer.play(file.path);
        this._lastResult = null;
        this._lastDownload = null;
        setState(() {
          this._msg = "downloaded";
        });
      },
      onFail: () {
        this._lastResult = null;
        this._lastDownload = null;
      },
    );
    HttpService.instance.downloadFile(this._lastDownload);
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
          Expanded(
            child: WebView(
              initialUrl: this._urlTxt,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Text(
                "Lien actuel"
            ),
          ),
          TextField(
            readOnly: true,
            controller: _textController,
          ),LinearProgressIndicator(
            value: 0
          ),
          FlatButton(
            color: Color.fromRGBO(255, 0, 0, 1),
            textColor: Color.fromRGBO(255, 255, 255, 1),
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
