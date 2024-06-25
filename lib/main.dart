import 'package:bunkerlink/screens/guide.dart';
import 'package:bunkerlink/screens/profile.dart';
import 'package:bunkerlink/screens/rooms.dart';
import 'package:bunkerlink/services/auth/gate.dart';
import 'package:bunkerlink/services/auth/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'screens/map.dart';
import 'screens/chat.dart';
import 'screens/sos.dart';
import 'screens/front.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FrontScreen(),
      routes: {
        '/map': (context) => AuthGate(screen: MapScreen()),
        '/rooms': (context) => const AuthGate(screen: RoomsScreen()),
        '/sos': (context) => AuthGate(screen: SosScreen()),
        '/profile': (context) => const AuthGate(screen: ProfileScreen()),
        '/guide': (context) => const AuthGate(screen: GuideScreen()),
        '/chat': (context) => AuthGate(screen: ChatScreen()),
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
    RoomsScreen(),
    MapScreen(),
    SosScreen(),
    GuideScreen(),
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
