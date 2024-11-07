import 'dart:ffi';

import 'package:application/views/state/appbloc.dart';
import 'package:application/Models/Location.dart';
import 'package:application/views/widgets/Orders/ConfirmOrder.dart';
import 'package:application/views/widgets/Orders/CreatOrder.dart';
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

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng? currentLocation;
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();
  bool _selectedCurrentLocation = false;
  bool _isSearchExpanded = false;
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

  final String googleApiKey = 'AIzaSyDWLUTXrMptRP5s-9KlQbKREHZVZ1nNSLE';

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
    return Scaffold(
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
                                  'Set delivery location',
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
                                const SizedBox(height: 16),

                                // FutureBuilder
                                Flexible(
                                  child: FutureBuilder<List<LocationModel>>(
                                    future: AppRequest.fetchLocations(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<LocationModel>>
                                            snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.error_outline,
                                                  color: Colors.red, size: 48),
                                              const SizedBox(height: 16),
                                              Text(
                                                'Error: ${snapshot.error}',
                                                style: TextStyle(
                                                    color: Colors.red[700]),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return const Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.location_off,
                                                  color: Colors.grey, size: 48),
                                              SizedBox(height: 16),
                                              Text(
                                                'No saved locations available',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        final data = snapshot.data!;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                              child: Text(
                                                'Saved Places',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: data.length,
                                              itemBuilder: (context, index) {
                                                final location = data[index];
                                                return InkWell(
                                                  onTap: () {
                                                    _moveToLocation(
                                                        location.lat,
                                                        location.lng);

                                                    setState(() {
                                                      selectedLocation =
                                                          location.place;
                                                      _selectedCurrentLocation =
                                                          false;
                                                    });

                                                    context
                                                        .read<Appbloc>()
                                                        .changeLocation(
                                                            location);
                                                  },
                                                  child: Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 16,
                                                      vertical: 4,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    decoration: BoxDecoration(
                                                      color: !_selectedCurrentLocation &&
                                                              selectedLocation ==
                                                                  location.place
                                                          ? Colors.blue
                                                              .withOpacity(0.1)
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                        color: !_selectedCurrentLocation &&
                                                                selectedLocation ==
                                                                    location
                                                                        .place
                                                            ? Colors.blue
                                                                .withOpacity(
                                                                    0.3)
                                                            : Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.05),
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                              0, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.location_on,
                                                          color: !_selectedCurrentLocation &&
                                                                  selectedLocation ==
                                                                      location
                                                                          .place
                                                              ? Colors.blue
                                                              : Colors.grey,
                                                        ),
                                                        const SizedBox(
                                                            width: 12),
                                                        Expanded(
                                                          child: Text(
                                                            location.place,
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: !_selectedCurrentLocation &&
                                                                      selectedLocation ==
                                                                          location
                                                                              .place
                                                                  ? FontWeight
                                                                      .w600
                                                                  : FontWeight
                                                                      .normal,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ),

                                const SizedBox(height: 16),
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

                                const SizedBox(height: 24),

// Proceed Button
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // final Map<String, dynamic> body = {
                                      //   "lat": lat,
                                      //   "lng": lng,
                                      //   "locationName": locationName,
                                      // };
                                      // print(Provider.of<Appbloc>(context,
                                      //         listen: false)
                                      //     .location);

                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: ConfirmOrder(),
                                        withNavBar: true,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                      shadowColor: Colors.blue.withOpacity(0.3),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'PROCEED TO ORDER',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(Icons.arrow_forward, size: 20),
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
                          googleAPIKey: googleApiKey,
                          inputDecoration: InputDecoration(
                            hintText: 'Search location',
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
