import 'package:bunkerlink/widgets/CustomBottomNavigationBar.dart';
import 'package:bunkerlink/widgets/MyButton.dart';
import 'package:flutter/material.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rooms'),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
          child: MyButton(
              onTap: () {
                Navigator.pushNamed(context, '/chat');
              },
              text: 'Chat')),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}
