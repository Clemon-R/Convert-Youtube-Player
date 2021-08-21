import 'package:flutter/material.dart';

class DownloadComponent extends StatelessWidget {
  DownloadComponent(
      {required this.onPressDownload,
      required this.disable,
      required this.infoMessage,
      required this.downloadProgress});

  final Function() onPressDownload;

  final bool disable;
  final String infoMessage;
  final double downloadProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(34, 40, 49, 1.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: this.downloadProgress,
            backgroundColor: Colors.grey,
            minHeight: 10,
            valueColor: AlwaysStoppedAnimation(Colors.red),
          ),
          Text(this.infoMessage, style: TextStyle(color: Colors.white)),
          ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
              minimumSize: MaterialStateProperty.all(Size(32, 32)),
              backgroundColor: MaterialStateProperty.all(this.disable
                  ? Color.fromRGBO(240, 84, 84, 0.5)
                  : Color.fromRGBO(240, 84, 84, 1)),
            ),
            child: Text("Télécharger",
                style: TextStyle(
                    color: this.disable
                        ? Color.fromRGBO(221, 221, 221, 1)
                        : Colors.white)),
            onPressed: !this.disable ? this.onPressDownload : null,
          )
        ],
      ),
    );
  }
}
