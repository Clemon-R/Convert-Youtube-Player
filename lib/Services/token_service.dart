import 'package:webview_flutter/webview_flutter.dart';

class TokenService {
  static const String TAG = "TokenService";

  static TokenService _instance = TokenService();
  static TokenService get instance => _instance;

  WebViewController _webViewController;
  String _token;
  String _xsrfToken;
  bool _initiated = false;

  WebViewController get webViewController => this._webViewController;
  String get token => this._token;
  String get xsrfToken => this._xsrfToken;
  bool get initiated => this._initiated;

  void setController(WebViewController controller) {
    this._webViewController = controller;
  }

  Future<void> init() async {
    print("$TAG: Init...");
    this._token = await this._getToken();
    this._xsrfToken = await this._getXsrfToken();
    this._initiated = true;
    print("$TAG: Initied");
  }

  Future<String> _getXsrfToken() async {
    if (this._webViewController == null) {
      print("$TAG(ERROR): WebViewController not set");
      return "";
    }
    final String cookies =
        await this._webViewController.evaluateJavascript('document.cookie');
    RegExp exp = new RegExp(r"XSRF-TOKEN=([a-zA-Z0-9]+)");

    Iterable<Match> matches = exp.allMatches(cookies);
    if (matches == null) {
      print("$TAG(ERROR): XsrfToken not found");
      return null;
    } else {
      final matchedText = matches.elementAt(0).group(1);
      return matchedText;
    }
  }

  Future<String> _getToken() async {
    if (this._webViewController == null) {
      print("$TAG(ERROR): WebViewController not set");
      return "";
    }
    String html = await this._webViewController.evaluateJavascript(
        "window.document.getElementsByTagName('html')[0].outerHTML;");
    RegExp exp = new RegExp(r"token\s=\s'([a-zA-Z0-9]+)'");

    Iterable<Match> matches = exp.allMatches(html);
    if (matches == null) {
      print("$TAG(ERROR): Token not found");
      return null;
    } else {
      final matchedText = matches.elementAt(0).group(1);
      return matchedText;
    }
  }
}
