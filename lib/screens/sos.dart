import 'package:bunkerlink/services/chat/service.dart';
import 'package:flutter/material.dart';
import 'package:bunkerlink/widgets/CustomBottomNavigationBar.dart';
import 'package:geolocator/geolocator.dart';

class SosScreen extends StatefulWidget {
  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  final ChatService _chatService = ChatService();

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

  void _showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<void> sendCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      // accessing the position and inform the user.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returns true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();

    await _chatService.sendSOS(position);
  }

  void _showHelpDialog(BuildContext context) {
    _showDialog(
      context: context,
      title: 'SOS',
      content: 'Sent your location to everyone! Help is on the way!',
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
            _showLoading(context);
            sendCurrentLocation().then((_) {
              Navigator.of(context).pop();
              _showHelpDialog(context);
            }).catchError((error) {
              Navigator.of(context).pop();
              _showDialog(
                context: context,
                title: 'Error',
                content: error.toString(),
                actions: [
                  TextButton(
                    child:
                        const Text('OK', style: TextStyle(color: Colors.green)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
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
