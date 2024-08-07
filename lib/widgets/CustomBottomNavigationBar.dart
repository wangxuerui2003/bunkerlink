import 'package:bunkerlink/screens/guide.dart';
import 'package:bunkerlink/screens/map.dart';
import 'package:bunkerlink/screens/profile.dart';
import 'package:bunkerlink/screens/rooms.dart';
import 'package:bunkerlink/screens/sos.dart';
import 'package:bunkerlink/services/auth/gate.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      if (index != currentIndex) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    const AuthGate(screen: RoomsScreen()),
                transitionDuration: Duration.zero,
              ),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => MapScreen(),
                transitionDuration: Duration.zero,
              ),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => AuthGate(screen: SosScreen()),
                transitionDuration: Duration.zero,
              ),
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    const AuthGate(screen: GuideScreen()),
                transitionDuration: Duration.zero,
              ),
            );
            break;            
          case 4:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    const AuthGate(screen: ProfileScreen()),
                transitionDuration: Duration.zero,
              ),
            );
            break;
        }
      }
    }

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.house),
          label: 'Rooms',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.warning),
          label: 'SOS',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.question_mark_outlined),
          label: 'Guide',
        ),        
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: currentIndex,
      showUnselectedLabels: true,
      selectedItemColor: Colors.lightGreen,
      unselectedItemColor: Colors.black54,
      onTap: _onItemTapped,
      selectedFontSize: 12.0,
      unselectedFontSize: 12.0,
    );
  }
}
