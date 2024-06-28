import 'package:flutter/material.dart';
import 'package:bunkerlink/widgets/CustomBottomNavigationBar.dart';

class SosScreen extends StatelessWidget {
  void _showDialog({
    required BuildContext context,
    required String title,
    required String content,
    required List<Widget> actions,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: actions,
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    _showDialog(
      context: context,
      title: 'SOS',
      content: 'Help is on the way!',
      actions: [
        TextButton(
          child: const Text('OK', style: TextStyle(color: Colors.green)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    _showDialog(
      context: context,
      title: 'Confirmation',
      content: 'Are you sure you want to send an SOS?',
      actions: [
        TextButton(
          child: const Text('Cancel', style: TextStyle(color: Colors.green)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Yes', style: TextStyle(color: Colors.green)),
          onPressed: () {
            Navigator.of(context).pop();
            _showHelpDialog(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showConfirmationDialog(context),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning,
                color: Colors.white,
                size: 35.0,
              ),
              SizedBox(width: 8.0),
              Text(
                'SOS!',
                style: TextStyle(
                  fontSize: 35.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {},
      ),
    );
  }
}