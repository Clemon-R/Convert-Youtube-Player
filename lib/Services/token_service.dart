import 'package:webview_flutter/webview_flutter.dart';

class TokenService {
  static const String TAG = "TokenService";

  WebViewController _webViewController;
  String _token;
  String _xsrfToken;

  WebViewController get webViewController => this._webViewController;
  String get token => this._token;
  String get xsrfToken => this._xsrfToken;

  Future<void> init(WebViewController controller) async {
    print("$TAG: Init...");
    this._webViewController = controller;
    this._token = await this._getToken();
    this._xsrfToken = await this._getXsrfToken();
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
