import 'package:bunkerlink/widgets/CustomBottomNavigationBar.dart';
import 'package:flutter/material.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  _SosScreenState createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  final int _selectedIndex = 2; // Remove this line

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/chat');
        break;
      case 1:
        Navigator.pushNamed(context, '/map');
        break;
      case 2:
        // Optional: You might want to check if you are already on the sos screen
        // before pushing it again.
        Navigator.pushNamed(context, '/sos');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;        
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('SOS Screen'),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex, // Pass _selectedIndex here
        onTap: _onItemTapped,
      ),      
    );
  }
}
