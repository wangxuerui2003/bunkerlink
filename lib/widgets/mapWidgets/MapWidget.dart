import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


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
  bool isLoading = true;

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isLocationEnabled) {
      _checkLocationPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(3.1390, 101.6869),
            zoom: 11.0,
          ),
          myLocationEnabled: widget.isLocationEnabled,
          myLocationButtonEnabled: true,
          markers: Set<Marker>.of(markers),
        ),
        if (isLoading)
          Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    if (widget.isLocationEnabled) {
      _fetchNearbyHospitals();
    }
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show a message to the user
      setState(() {
        isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, show a message to the user
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, show a message to the user
      setState(() {
        isLoading = false;
      });
      return;
    }

    // If permissions are granted, fetch nearby hospitals
    _fetchNearbyHospitals();
  }

  Future<void> _fetchNearbyHospitals() async {
    try {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Fetch nearby hospitals using Places API
      List<Marker> newMarkers = await _getNearbyHospitals(position);

      // Clear existing markers and update state
      setState(() {
        markers.clear();
        markers.addAll(newMarkers);
        isLoading = false;
      });
    } catch (e) {
      // Handle the exception, e.g., show an error message
      setState(() {
        isLoading = false;
      });
    }
  }

  // Help me to get add icon and change the label to "shelter"
  Future<List<Marker>> _getNearbyHospitals(Position position) async {
    List<Marker> newMarkers = [];
    String apiKey = 'AIzaSyDEeSyYedSX-iemRyqMhDnh3QVx0dRVeNE';
    String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&radius=5000&type=hospital&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final results = json['results'];

      for (var result in results) {
        final lat = result['geometry']['location']['lat'];
        final lng = result['geometry']['location']['lng'];
        final name = result['name'];

        newMarkers.add(
          Marker(
            markerId: MarkerId(result['place_id']),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: name,
              snippet: 'Shelter',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
        );
      }
    } else {
      // help me to use a logging framework to see the error
      
    }

    return newMarkers;
  }
}
