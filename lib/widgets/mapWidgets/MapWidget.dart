import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapWidget extends StatefulWidget {
  final bool isLocationEnabled;

  MapWidget({
    Key? key,
    required this.isLocationEnabled,
  }) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController mapController;
  List<Marker> markers = [];

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: const CameraPosition(
        target: LatLng(3.1390, 101.6869),
        zoom: 11.0,
      ),
      myLocationEnabled: widget.isLocationEnabled,
      myLocationButtonEnabled: true,
      markers: Set<Marker>.of(markers),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    _fetchNearbyHospitals();
  }

  Future<void> _fetchNearbyHospitals() async {
    if (!widget.isLocationEnabled) return;

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Fetch nearby hospitals within a certain radius
    List<Marker> newMarkers = await _getNearbyHospitals(position);

    // Clear existing markers and update state
    setState(() {
      markers.clear();
      markers.addAll(newMarkers);
    });
  }

  Future<List<Marker>> _getNearbyHospitals(Position position) async {
    List<Marker> newMarkers = [];

    // Simulate fetching nearby hospitals within a radius (adjust as needed)
    // In a real application, you would fetch this data from a backend or a specific API
    // For demonstration, we'll add a few mock markers
    for (int i = 0; i < 5; i++) {
      double lat = position.latitude + (i * 0.001);
      double lng = position.longitude + (i * 0.001);
      String markerId = 'hospital_$i';

      newMarkers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: 'Hospital $i',
            snippet: 'Shelter',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    }

    return newMarkers;
  }
}
