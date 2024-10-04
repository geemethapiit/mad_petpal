import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  GoogleMapController? _mapController;
  LatLng _initialPosition = const LatLng(6.9271, 79.8612); // Default to Colombo, Sri Lanka
  Position? _currentPosition;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      // Permission granted, proceed with location access
      print("Location permission granted");
      _getCurrentLocation(); // Request location after permission is granted
    } else if (status.isDenied) {
      // Permission denied, show an alert or handle appropriately
      print("Location permission denied");
    } else if (status.isPermanentlyDenied) {
      // Handle permanent denial by opening app settings
      openAppSettings();
    }
  }

  Future<void> _getCurrentLocation() async {
    // Request location permission
    PermissionStatus permission = await Permission.location.request();
    if (permission.isGranted) {
      // Get current location
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _initialPosition =
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

        // Update the map and add a marker for the current location
        _markers.add(
          Marker(
            markerId: MarkerId('currentLocation'),
            position: _initialPosition,
            infoWindow: InfoWindow(title: 'Current Location'),
          ),
        );

        // Move camera to the current location
        if (_mapController != null) {
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(_initialPosition),
          );
        }
      });
    } else {
      // Handle permission denied scenario
      print("Location permission denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _markers, // Display markers on the map
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                // Update camera position to initial position after map is created
                _mapController?.animateCamera(
                  CameraUpdate.newLatLng(_initialPosition),
                );
              },
            ),
          ),
          Positioned(
            top: 60.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Positioned(
            top: 150.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                _getCurrentLocation();
              },
              backgroundColor: Colors.white,
              child: Icon(
                Icons.my_location,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
