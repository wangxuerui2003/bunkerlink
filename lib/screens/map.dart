import 'package:bunkerlink/widgets/mapWidgets/GooglePlaceAutoCompleteTextField.dart';
import 'package:bunkerlink/widgets/mapWidgets/MapWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bunkerlink/widgets/CustomBottomNavigationBar.dart';

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
          MapWidget(
            isLocationEnabled: _isLocationEnabled,
          ),
          LocationSearchWidget(controller: controller),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
