import 'package:youtekmusic/services/iservice.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TokenService extends IService {
  static const String TAG = "TokenService";

  WebViewController? _webViewController;
  String? _token;
  String? _xsrfToken;
  String? _cookie;
  bool _initiated = false;

  WebViewController? get webViewController => this._webViewController;
  String? get token => this._token;
  String? get xsrfToken => this._xsrfToken;
  String? get cookie => this._cookie;
  bool get initiated => this._initiated;

  void setController(WebViewController controller) {
    this._webViewController = controller;
  }

  Future<void> init([String? cookies]) async {
    print("$TAG: Init...");
    this._token = await this._getToken();
    this._xsrfToken = await this._getXsrfToken(cookies);
    if (cookies != null) {
      this._cookie = this._getCleanCookie(cookies);
      print("$TAG: Cookie ${this._cookie}");
    }
    this._initiated = true;
    print("$TAG: Initied");
  }

  String? _getCleanCookie(String cookies) {
    if (this._webViewController == null) {
      print("$TAG(ERROR): WebViewController not set");
      return "";
    }
    RegExp exp = new RegExp(r"(mp3_youtube_session=.+)");

    Iterable<Match> matches = exp.allMatches(cookies);
    if (matches.isEmpty) {
      print("$TAG(ERROR): Cookie not found");
      return null;
    } else {
      final matchedText = matches.elementAt(0).group(1);
      print("$TAG: Cookie found $matchedText");
      return matchedText;
    }
  }

  Future<String?> _getXsrfToken([String? cookies]) async {
    if (this._webViewController == null) {
      print("$TAG(ERROR): WebViewController not set");
      return "";
    }
    if (cookies == null)
      cookies =
          await this._webViewController!.evaluateJavascript('document.cookie');
    RegExp exp = new RegExp(r"XSRF-TOKEN=([a-zA-Z0-9]+)");

    Iterable<Match> matches = exp.allMatches(cookies);
    if (matches.isEmpty) {
      print("$TAG(ERROR): XsrfToken not found");
      return null;
    } else {
      final matchedText = matches.elementAt(0).group(1);
      print("$TAG: X-xsrf-Token found $matchedText");
      return matchedText;
    }
  }

  Future<String?> _getToken() async {
    if (this._webViewController == null) {
      print("$TAG(ERROR): WebViewController not set");
      return "";
    }
    String html = await this._webViewController!.evaluateJavascript(
        "window.document.getElementsByTagName('html')[0].outerHTML;");
    RegExp exp = new RegExp(r"token\s=\s'([a-zA-Z0-9]+)'");

    Iterable<Match> matches = exp.allMatches(html);
    if (matches.isEmpty) {
      print("$TAG(ERROR): Token not found");
      return null;
    } else {
      final matchedText = matches.elementAt(0).group(1);
      print("$TAG: X-Token found $matchedText");
      return matchedText;
    }
  }
}
