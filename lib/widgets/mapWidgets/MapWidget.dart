import 'dart:async';
import 'dart:convert';
import 'package:bunkerlink/env/environment.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapWidget extends StatefulWidget {
  final bool isLocationEnabled;
  final Function(GoogleMapController) onMapCreated;
  final CameraPosition initialCameraPosition;
  final bool emergency;

  MapWidget({
    Key? key,
    required this.isLocationEnabled,
    required this.onMapCreated,
    required this.initialCameraPosition,
    this.emergency = false,
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
          onMapCreated: (controller) {
            mapController = controller;
            widget.onMapCreated(controller);
            _onMapCreated(controller);
          },
          initialCameraPosition: widget.initialCameraPosition,
          myLocationEnabled: widget.isLocationEnabled,
          myLocationButtonEnabled: true,
          markers: widget.emergency
              ? {
                  Marker(
                    markerId: const MarkerId('1'),
                    position: LatLng(
                        widget.initialCameraPosition.target.latitude,
                        widget.initialCameraPosition.target.longitude),
                  )
                }
              : Set<Marker>.of(markers),
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    if (widget.isLocationEnabled) {
      _fetchNearbyHospitals();
    }
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorSnackBar("Location services are disabled.");
        setState(() {
          isLoading = false;
        });
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorSnackBar("Location permissions are denied.");
          setState(() {
            isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorSnackBar("Location permissions are permanently denied.");
        setState(() {
          isLoading = false;
        });
        return;
      }

      _fetchNearbyHospitals();
    } catch (e) {
      _showErrorSnackBar("Error checking location permissions: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchNearbyHospitals() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Marker> newMarkers = await _getNearbyHospitals(position);

      setState(() {
        markers.clear();
        markers.addAll(newMarkers);
        isLoading = false;
      });
    } catch (e) {
      _showErrorSnackBar("Error fetching nearby hospitals: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Marker>> _getNearbyHospitals(Position position) async {
    List<Marker> newMarkers = [];
    String apiKey = Environment.googleApiKey;
    String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&radius=5000&type=hospital&key=$apiKey';

    try {
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
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure),
            ),
          );
        }
      } else {
        _showErrorSnackBar(
            "Error fetching data from API: ${response.statusCode}");
      }
    } catch (e) {
      _showErrorSnackBar("Error fetching data from API: $e");
    }

    return newMarkers;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
