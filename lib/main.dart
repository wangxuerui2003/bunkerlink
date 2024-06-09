import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/bunker.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 20.0),              
              const Text(
                'Bunkerlink',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Find the nearest bunkers and get help!',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  // Add your button functionality here
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.lightGreen), // Background color
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Adjust the value as needed
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.start, // You can choose any icon you prefer
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white, // Text color
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
