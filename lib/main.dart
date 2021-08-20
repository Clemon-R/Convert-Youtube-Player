import 'package:youtekmusic/provider/services_provider.dart';
import 'package:youtekmusic/views/main_view.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ServicesProvider.prepareAllServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Musique',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        initialData: ServicesProvider.isReady,
        future: ServicesProvider.initializeApp(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == true)
            return MainView();
          else
            return Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
