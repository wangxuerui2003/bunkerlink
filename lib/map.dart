import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 11.0,
        ),
        myLocationEnabled: _isLocationEnabled,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
