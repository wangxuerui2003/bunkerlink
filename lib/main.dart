import 'package:flutter/material.dart';
import 'map.dart';
import 'home.dart';
import 'chat.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FrontScreen(),
      routes: {
        '/map': (context) => MapScreen(),
        '/chat': (context) => ChatScreen(),
      },
    );
  }
}
