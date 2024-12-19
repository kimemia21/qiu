import 'dart:convert';
import 'dart:ffi';

import 'package:application/comms/comms_repo.dart';
import 'package:application/comms/credentials.dart';
import 'package:application/views/widgets/WSP/homepage/WSPHomePage.dart';
import 'package:application/views/widgets/globals.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../state/appbloc.dart';
import '../../../Models/Location.dart';
import '../Orders/ConfirmOrder.dart';
import '../Orders/CreatOrder.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../../comms/Req.dart';

class RegisterWsp extends StatefulWidget {
  const RegisterWsp({Key? key}) : super(key: key);

  @override
  State<RegisterWsp> createState() => _RegisterWspState();
}

class _RegisterWspState extends State<RegisterWsp> {
  GoogleMapController? mapController;
  LatLng? currentLocation;
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();
  bool _selectedCurrentLocation = false;
  bool _isSearchExpanded = false;
  final TextEditingController _companyName = TextEditingController();

  Map<String, dynamic> waterSource = {
    "Borehole": "Borehole",
    "Well": "Well",
    "Spring": "Spring",
    "Stream": "Stream",
    "River": "River",
    "Lake": "Lake",
    "Pond": "Pond",
    "Other": "Other",
  };
  Map<String, dynamic> waterQuality = {
    "fresh": "fresh",
  };
  String? selectedWaterSource;
  String? selectedWaterQuality;
  List<Map<String, dynamic>> locationOptions = [
    {
      "Home": "50.11466 Longitude: -94.522643",
      "description": "HSE number 3568",
    },
    {
      "Office": " 50.11466 Longitude: -94.522643",
      "description": "HSE number 3568",
    },
  ];
  String? selectedLocation;

  // Default camera position (Nairobi)
  final LatLng defaultLocation = const LatLng(-1.2921, 36.8219);
  double? lat;
  double? lng;
  String? locationName;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => isLoading = false);
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => isLoading = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);

        lat = position.latitude;
        lng = position.longitude;
        isLoading = false;
      });

      if (mapController != null && currentLocation != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: currentLocation!,
              zoom: 15,
            ),
          ),
        );
      }

      // Reverse geocode to get the description
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String description =
            "${place.name}, ${place.administrativeArea}, ${place.country}";
        var _location = {
          'currentLocation': currentLocation,
          'description': description,
        };

        LocationModel location = LocationModel(
            lng: currentLocation!.latitude,
            lat: currentLocation!.longitude,
            description: description,
            place: "Current Location");

        context.read<Appbloc>().changeLocation(location);
        // context.read<Appbloc>().changeDeliveryDetails(
        //       lat: "${currentLocation!.latitude}",
        //       long: "${currentLocation!.longitude}",
        //       additionalInfo: description,
        //     );

        print(_location);

        setState(() {
          locationName = description;
        });
      }
    } catch (e) {
      print("Error getting location: $e");
      setState(() => isLoading = false);
    }
  }

  void _moveToLocation(double lat, double lng) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 15,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      selectedWaterSource = waterSource.keys.first;
      selectedWaterQuality = waterQuality.keys.first;
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Register Wsp Details",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w400),
        ),
        backgroundColor: appGradient[0],
      ),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: Column(
                    children: [
                      // Map taking 55% of the screen height
                      Flexible(
                        flex: 11,
                        child: GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            setState(() {
                              mapController = controller;
                              if (currentLocation != null) {
                                controller.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: currentLocation!,
                                      zoom: 15,
                                    ),
                                  ),
                                );
                              }
                            });
                          },
                          initialCameraPosition: CameraPosition(
                            target: currentLocation ?? defaultLocation,
                            zoom: 15,
                          ),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: true,
                          mapType: MapType.normal,
                        ),
                      ),

                      // Bottom sheet with location selection
                      Expanded(
                        flex: 9,
                        child: SingleChildScrollView(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Set WSP Location',
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),

                                // Search location field
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isSearchExpanded = true;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: TextField(
                                      enabled: false,
                                      decoration: InputDecoration(
                                        hintText: 'Search location',
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
                                        ),
                                        prefixIcon: const Icon(Icons.search),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: InkWell(
                                    onTap: () {
                                      try {
                                        if (currentLocation != null &&
                                            locationName != null) {
                                          setState(() =>
                                              _selectedCurrentLocation = true);
                                          mapController?.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                target: currentLocation!,
                                                zoom: 20,
                                              ),
                                            ),
                                          );

                                          final LocationModel location =
                                              LocationModel(
                                                  // Fix: Use currentLocation's coordinates instead of lng for both
                                                  lng: currentLocation!
                                                      .longitude,
                                                  lat:
                                                      currentLocation!.latitude,
                                                  description: locationName!,
                                                  place: "Current Location");

                                          context
                                              .read<Appbloc>()
                                              .changeLocation(location);
                                        } else {
                                          // Show error message to user
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Unable to get current location. Please try again.'),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        print("current location error $e");
                                        // Show error message to user
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('Error: $e'),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: _selectedCurrentLocation
                                            ? Colors.blue.withOpacity(0.1)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _selectedCurrentLocation
                                              ? Colors.blue.withOpacity(0.3)
                                              : Colors.grey.withOpacity(0.2),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.my_location,
                                            color: _selectedCurrentLocation
                                                ? Colors.blue
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 12),
                                          const Text(
                                            "Use Current Location",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _companyName,
                                    decoration: InputDecoration(
                                      labelText: "Enter Company name",
                                      hintText: "Company name......",
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Colors
                                              .blueAccent, // Border color when not focused
                                          width: 2.5, // Border thickness
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Colors
                                              .deepPurple, // Border color when focused
                                          width:
                                              2.0, // Border thickness when focused
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Colors
                                              .redAccent, // Border color when error occurs
                                          width: 1.5,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Colors
                                              .red, 
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: DropdownMenu<String>(
                                    hintText: "Select water type",
                                    menuStyle: MenuStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      elevation: MaterialStateProperty.all(
                                          8), // Menu shadow
                                    ),
                                    inputDecorationTheme:
                                        const InputDecorationTheme(
                                      contentPadding: EdgeInsets.all(12),
                                      border: InputBorder
                                          .none, // Remove default input border
                                    ),
                                    initialSelection: selectedWaterSource,
                                    dropdownMenuEntries: waterSource.entries
                                        .map((entry) =>
                                            DropdownMenuEntry<String>(
                                              value: entry.value,
                                              label: entry.key,
                                            ))
                                        .toList(),
                                    onSelected: (value) {
                                      setState(() {
                                        selectedWaterSource = value;
                                      });
                                    },
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: DropdownMenu<String>(
                                    hintText: "Select water quality",
                                    menuStyle: MenuStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      elevation: MaterialStateProperty.all(
                                          8), // Menu shadow
                                    ),
                                    inputDecorationTheme:
                                        const InputDecorationTheme(
                                      contentPadding: EdgeInsets.all(12),
                                      border: InputBorder
                                          .none, // Remove default input border
                                    ),
                                    initialSelection: selectedWaterQuality,
                                    dropdownMenuEntries: waterQuality.entries
                                        .map((entry) =>
                                            DropdownMenuEntry<String>(
                                              value: entry.value,
                                              label: entry.key,
                                            ))
                                        .toList(),
                                    onSelected: (value) {
                                      setState(() {
                                        selectedWaterQuality = value;
                                      });
                                    },
                                  ),
                                ),

// Proceed Button
                                context.watch<Appbloc>().isLoading
                                    ? SpinKitThreeBounce(
                                        color: Colors.blue,
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            final Map<String, dynamic> body = {
                                              "role": "WSP",
                                              "lat": lat.toString(),
                                              "log": lng.toString(),
                                              "physicalAddress": locationName.toString(),
                                              "quality": selectedWaterQuality,
                                              "waterSource":
                                                  selectedWaterSource,
                                              "companyName":
                                                  _companyName.text.trim()
                                            };

                                            CommsRepository()
                                                .QueryAPIpost(
                                                    "users/register-service",
                                                    jsonEncode(body),
                                                    context)
                                                .then((value) {
                                              if (value["status"] ==
                                                  "success") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        WSPHomePage(),
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(value[
                                                            "message"] ??
                                                        "An error occurred"),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }

                                              print(value);
                                            });

                                            // print(Provider.of<Appbloc>(context,
                                            //         listen: false)
                                            //     .location);

                                            // PersistentNavBarNavigator.pushNewScreen(
                                            //   context,
                                            //   screen: ConfirmOrder(),
                                            //   withNavBar: true,
                                            // );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: 2,
                                            shadowColor:
                                                Colors.blue.withOpacity(0.3),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Register',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Icon(Icons.arrow_forward,
                                                  size: 20),
                                            ],
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

          // Full-screen search overlay
          if (_isSearchExpanded)
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: SafeArea(
                  child: Column(
                    children: [
                      // Header with back button
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                setState(() {
                                  _isSearchExpanded = false;
                                  searchController.clear();
                                });
                              },
                            ),
                            Expanded(
                              child: Text(
                                'Search Location',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Search TextField
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GooglePlaceAutoCompleteTextField(
                          textEditingController: searchController,
                          googleAPIKey: googleMapsApiKey,
                          inputDecoration: InputDecoration(
                            hintText: 'Search Location',
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            prefixIcon: const Icon(Icons.search),
                          ),
                          debounceTime: 800,
                          countries: const ["ke"],
                          isLatLngRequired: true,
                          getPlaceDetailWithLatLng: (Prediction prediction) {
                            setState(() {
                              lat = double.parse(prediction.lat ?? "0");
                              lng = double.parse(prediction.lng ?? "0");
                              locationName =
                                  prediction.description ?? "no description";
                              _isSearchExpanded = false;

                              // context.read<Appbloc>().changeDeliveryDetails(
                              //       lat: "${lat}",
                              //       long: "${lng}",
                              //       address: locationName,
                              //       additionalInfo: "description",
                              //     );
                            });
                            _moveToLocation(lat!, lng!);
                          },
                          itemClick: (Prediction prediction) {
                            searchController.text =
                                prediction.description ?? "";
                            searchController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: searchController.text.length),
                            );
                          },
                          itemBuilder: (context, _, prediction) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.red),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      prediction.description ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          seperatedBuilder: const Divider(),
                          isCrossBtnShown: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    searchController.dispose();
    super.dispose();
  }
}
