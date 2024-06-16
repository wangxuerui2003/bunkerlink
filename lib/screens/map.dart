import 'package:bunkerlink/env/environment.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/model/prediction.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng _initialPosition = const LatLng(3.1390, 101.6869);
  bool _isLocationEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _goToCurrentLocation();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      setState(() {
        _isLocationEnabled = true;
      });
    }
  }

  Future<void> _goToCurrentLocation() async {
    if (!_isLocationEnabled) return;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Scaffold(
      body: Column(
        children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: controller,
                googleAPIKey: "AIzaSyDEeSyYedSX-iemRyqMhDnh3QVx0dRVeNE",
                debounceTime: 800, // Optional: default is 600 ms
                isLatLngRequired: true, // Optional: request LatLng with place detail
                getPlaceDetailWithLatLng: (Prediction prediction) {
                  // Callback when LatLng is required
                  print("Place Details: ${prediction.lat}, ${prediction.lng}");
                },
                itemClick: (Prediction prediction) {
                  // Callback when an item is clicked
                  controller.text = prediction.description ?? "";
                  controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: prediction.description!.length));
                },
                itemBuilder: (context, index, Prediction prediction) {
                  // Custom item builder
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 7),
                        Expanded(child: Text("${prediction.description ?? ""}")),
                      ],
                    ),
                  );
                },
                seperatedBuilder: Divider(), // Optional: add a separator between items
                isCrossBtnShown: true, // Optional: show a close icon
                containerHorizontalPadding: 10, // Optional: container padding
              ),
            ),          
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 11.0,
              ),
              myLocationEnabled: _isLocationEnabled,
              myLocationButtonEnabled: true,
            ),
          ),
        ],
      ),
    );
  }

}