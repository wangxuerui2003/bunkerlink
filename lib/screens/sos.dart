import 'package:flutter/material.dart';
import 'package:bunkerlink/widgets/CustomBottomNavigationBar.dart';

class SosScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('SOS Screen'),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {},
      ),
    );
  }
}
