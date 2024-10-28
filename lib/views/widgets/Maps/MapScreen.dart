import 'package:application/views/widgets/Orders/CreatOrder.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

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
  List<String> locationOptions = ['Home', 'Office', 'Current Location'];
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
    resizeToAvoidBottomInset: true, // Allow the widget to resize when the keyboard is shown
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              GoogleMap(
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
              // Search and location selection panel
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                        // Google Places Autocomplete widget
                        GooglePlaceAutoCompleteTextField(
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
                          ),
                          debounceTime: 800,
                          countries: const ["ke"],
                          isLatLngRequired: true,
                          getPlaceDetailWithLatLng: (Prediction prediction) {
                            setState(() {
                              lat = double.parse(prediction.lat ?? "0");
                              lng = double.parse(prediction.lng ?? "0");
                              locationName = prediction.description ?? "";
                            });

                            _moveToLocation(lat!, lng!);
                            print("this is the  lats and lngs----$lat, $lng, $locationName");
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
                          // Customize the suggestions list
                          itemBuilder: (context, int, prediction) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                  ),
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
                        const SizedBox(height: 16),
                        ...locationOptions.map((option) => InkWell(
                              onTap: () {
                                setState(() => selectedLocation = option);
                                if (option == 'Current Location' &&
                                    currentLocation != null) {
                                  mapController?.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: currentLocation!,
                                        zoom: 20,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedLocation == option
                                      ? Colors.grey[300]
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(option),
                              ),
                            )),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            final Map<String, dynamic> body = {
                              "lat": lat,
                              "lng": lng,
                              "locationName": locationName,
                            };

                            PersistentNavBarNavigator.pushNewScreen(
                              withNavBar: true,
                              context,
                              screen: CreateOrderScreen(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('PROCEED TO ORDER'),
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
