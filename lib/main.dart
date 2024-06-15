import 'package:flutter/material.dart';
import 'map.dart';
import 'chat.dart';
import 'sos.dart';
import 'front.dart';
import 'widgets/CustomBottomNavigationBar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'environment.dart';

void main() async {
  await dotenv.load(fileName: ".env");
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
        '/sos': (context) => SosScreen(),
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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}