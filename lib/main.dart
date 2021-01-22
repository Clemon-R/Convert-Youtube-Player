import 'package:convertyoutubeplayer/services/cache_service.dart';
import 'package:convertyoutubeplayer/views/main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
  CacheService.instance.loadCache();
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
          '/': (context) => MainPage(title: 'Principale'),
        });
  }
}
