import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Position? currentPosition;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Function to get current location
  Future<void> _getCurrentLocation() async {
    try {
      // Request location permission
      final permission = await Permission.location.request();
      
      if (permission.isGranted) {
        // Get current position
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        
        setState(() {
          currentPosition = position;
          isLoading = false;
        });

        // Animate camera to current position
        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 15.0,
              ),
            ),
          );
        }
      } else {
        // Handle permission denied
        setState(() {
          isLoading = false;
        });
        _showPermissionDeniedDialog();
      }
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission Required'),
          content: Text('Please enable location permissions to use the map.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading 
        ? Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                  if (currentPosition != null) {
                    controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(
                            currentPosition!.latitude,
                            currentPosition!.longitude,
                          ),
                          zoom: 15.0,
                        ),
                      ),
                    );
                  }
                },
                initialCameraPosition: CameraPosition(
                  target: currentPosition != null
                      ? LatLng(
                          currentPosition!.latitude,
                          currentPosition!.longitude,
                        )
                      : LatLng(0, 0), // Default position if location not available
                  zoom: 15.0,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                mapType: MapType.normal,
              ),
              // Optional: Add a button to recenter the map
              Positioned(
                right: 16,
                bottom: 96,
                child: FloatingActionButton(
                  onPressed: _getCurrentLocation,
                  child: Icon(Icons.my_location),
                  mini: true,
                ),
              ),
            ],
          ),
    );
  }
}