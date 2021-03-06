import 'package:fgj_2020/repair_wall.dart';
import 'package:fgj_2020/start_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // showPerformanceOverlay: true,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      title: 'Repair wall',
      // When using [initialRoute] don't use [home] property
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => StartScreen(),
      },
    );
  }
}
