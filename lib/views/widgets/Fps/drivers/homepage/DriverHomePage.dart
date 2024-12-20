import 'dart:async';
import 'package:application/comms/credentials.dart';
import 'package:application/utils/utils.dart';
import 'package:application/views/widgets/Fps/drivers/DriverProfile.dart';
import 'package:application/views/widgets/Fps/homepage/WspList.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:application/Authentication/OnBoardScreen.dart';
import 'package:application/comms/socketAPI.dart';
import 'package:application/views/widgets/Fps/homepage/infocard.dart';
import 'package:application/views/widgets/User/UserFp.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../globals.dart';

class DriverHomepage extends StatefulWidget {
  const DriverHomepage({super.key});

  @override
  State<DriverHomepage> createState() => _DriverHomepageState();
}

class _DriverHomepageState extends State<DriverHomepage> {
  LatLng currentLocation = LatLng(0, 0);
  double lat = 0;
  double lng = 0;
  bool isLoading = true;
  late Timer timer;


  @override
  void initState() {
    super.initState();
       socket.connect();
      socket.on('connect', (_) {
        print('Connected to server');
      });
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationPermissionDialog();
        return;
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        // Get current position
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: AndroidSettings(accuracy: LocationAccuracy.high),
        );

        setState(() {
          lat = position.latitude;
          lng = position.longitude;
          currentLocation = LatLng(lat, lng);
          isLoading = false;
        });

        _startLocationUpdates();
      }
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _startLocationUpdates() {
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      print("updating location");
      _updateDriverLocation();
    });
  }

  Future<void> _updateDriverLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(accuracy: LocationAccuracy.high),
      );

      setState(() {
        lat = position.latitude;
        lng = position.longitude;
        currentLocation = LatLng(lat, lng);
      });
      

   
      socket.emit('update driver', {
        "driverId": current_user.DriverId,
        "fpId": 3,
        "latitude": lat,
        "longitude": lng,
        "isAvailable": 1,
        "truckCapacity": current_user.truckCapacity,
        "truckPrice": current_user.truckCost,
        "truckLicencePlate": current_user.truckLicencePlate
      });
     
      
            // if (mounted) {
      //   SocketApi()
      //       .UpdateLocation(1, 2, lat, lng, 1, "10000", "3400", "KBC1234");
      // }
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission'),
          content: Text(
              'Location permission is required to use this feature. Please enable it in app settings.'),
          actions: <Widget>[
            TextButton(
              child: Text('Open Settings'),
              onPressed: () {
                Geolocator.openAppSettings();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
    socket.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appGradient[0],
        centerTitle: true,
        title: Text(
          "Driver HomePage",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: appGradient),
        ),
        child: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
 
              SizedBox(height: 16),
              Text(
                "What would you like to do?",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    InfoCard(
                        title: "View Orders",
                        icon: Icons.add_shopping_cart,
                        color: Colors.blue,
                        tapped: () {}),
                    SizedBox(height: 16),
                    
                    InfoCard(
                        title: "Wsp",
                        icon: Icons.add_shopping_cart,
                        color: Colors.blue,
                        tapped: () {
                           Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WspDetailsScreen()

                                  //  MapScreen()
                                  ));
                        }),
                    SizedBox(height: 16),
                     InfoCard(
                        title: "Account",
                        icon: Icons.person,
                        color: Colors.black,
                        tapped: () {
                           Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DriverProfile()

                                  //  MapScreen()
                                  ));
                        }),

                    // InfoCard(
                    //     title: "Change to Service Provider",
                    //     icon: Icons.list,
                    //     color: Colors.black,
                    //     tapped: () {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => OnBoardScreen()

                    //               //  MapScreen()
                    //               ));
                    //     }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom method to build consistent action buttons
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue.shade400,
        minimumSize:
            Size(double.infinity, double.infinity), // Fill entire space
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(icon, size: 48), // Increased icon size
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(fontSize: 20), // Increased text size
          ),
        ],
      ),
    );
  }
}
