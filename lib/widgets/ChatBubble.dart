import 'package:bunkerlink/screens/map.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Chatbubble extends StatelessWidget {
  final String text;
  const Chatbubble({super.key, required this.text});

  Map<String, double> decodeLatLong(String message) {
    String latLong = message.split(":")[1];
    List<String> latLongList = latLong.split(",");
    return {
      "lat": double.parse(latLongList[0].trim()),
      "long": double.parse(latLongList[1].trim()),
    };
  }

  @override
  Widget build(BuildContext context) {
    bool isSOSMessage = text.startsWith("SOS");
    Map<String, double> latLong = isSOSMessage ? decodeLatLong(text) : {};

    if (isSOSMessage) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.lightGreen,
          borderRadius: BorderRadius.circular(8),
        ),
        child: RichText(
          text: TextSpan(
            children: [
              const WidgetSpan(
                child: Icon(Icons.location_on, size: 20.0, color: Colors.blue),
              ),
              TextSpan(
                text: " SOS!!!!!!",
                style: const TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Navigate to MapScreen with the decoded latitude and longitude
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                            lat: latLong["lat"]!, long: latLong["long"]!),
                      ),
                    );
                  },
              ),
            ],
          ),
        ),
      );
    }

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
