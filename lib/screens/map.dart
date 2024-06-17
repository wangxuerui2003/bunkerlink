import 'package:bunkerlink/env/environment.dart';
import 'package:bunkerlink/widgets/CustomBottomNavigationBar.dart';
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

    final int _selectedIndex = 1;
    void _onItemTapped(int index) {
      switch (index) {
        case 0:
          Navigator.pushNamed(context, '/chat');
          break;
        case 1:
          Navigator.pushNamed(context, '/map');
          break;
        case 2:
          Navigator.pushNamed(context, '/sos');
          break;
        case 3:
          Navigator.pushNamed(context, '/profile');
          break;
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 11.0,
            ),
            myLocationEnabled: _isLocationEnabled,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            top: 64.0,
            left: 8.0,
            right: 8.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0), // Adjust the radius as needed
              ),
              child: GooglePlaceAutoCompleteTextField(              
                textEditingController: controller,
                googleAPIKey: "AIzaSyDEeSyYedSX-iemRyqMhDnh3QVx0dRVeNE",
                debounceTime: 800,
                isLatLngRequired: true,
                inputDecoration: const InputDecoration(
                  hintText: 'Enter your location', // Placeholder text
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
            )

          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
