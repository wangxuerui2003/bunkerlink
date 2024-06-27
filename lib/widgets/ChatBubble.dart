import 'package:flutter/material.dart';

class Chatbubble extends StatelessWidget {
  final String text;
  const Chatbubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.lightGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text),
    );
  }
}
