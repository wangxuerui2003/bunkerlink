import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bunkerlink/widgets/mapWidgets/GooglePlaceAutoCompleteTextField.dart';
import 'package:bunkerlink/widgets/mapWidgets/MapWidget.dart';
import 'package:bunkerlink/widgets/CustomBottomNavigationBar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isLocationEnabled = false;
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
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

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _moveCameraToPosition(double lat, double lng) {
    mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(lat, lng),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            isLocationEnabled: _isLocationEnabled,
            onMapCreated: _onMapCreated,
          ),
          // LocationSearchWidget(
          //   controller: controller,
          //   onPlaceSelected: (lat, lng) {
          //     _moveCameraToPosition(lat, lng);
          //   },
          // ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }
}
