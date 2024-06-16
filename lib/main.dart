import 'package:bunkerlink/screens/profile.dart';
import 'package:flutter/material.dart';
import 'screens/map.dart';
import 'screens/chat.dart';
import 'screens/sos.dart';
import 'screens/front.dart';

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
        '/sos': (context) => const SosScreen(),
        '/profile': (context) => const ProfileScreen(),        
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    ChatScreen(),
    MapScreen(),
    const SosScreen(),
    const ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}