import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class LocationSearchWidget extends StatelessWidget {
  final TextEditingController controller;

  LocationSearchWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 64.0,
      left: 8.0,
      right: 8.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: GooglePlaceAutoCompleteTextField(
          textEditingController: controller,
          googleAPIKey: "AIzaSyDEeSyYedSX-iemRyqMhDnh3QVx0dRVeNE",
          debounceTime: 800,
          isLatLngRequired: true,
          inputDecoration: const InputDecoration(
            hintText: 'Enter your location',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16.0),
          ),
          getPlaceDetailWithLatLng: (Prediction prediction) {
            print("Place Details: ${prediction.lat}, ${prediction.lng}");
          },
          itemClick: (Prediction prediction) {
            controller.text = prediction.description ?? "Enter your location";
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0),
            );
          },
          itemBuilder: (context, index, Prediction prediction) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      prediction.description ?? "",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          },
          seperatedBuilder: const Divider(),
          isCrossBtnShown: true,
          containerHorizontalPadding: 10,
        ),
      ),
    );
  }
}
