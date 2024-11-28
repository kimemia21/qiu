import '../../Models/Location.dart';
import 'package:flutter/material.dart';

class Appbloc extends ChangeNotifier {
  LocationModel? _location;
  int? _quantityLiters;
  bool isLoading = false;
  String _destinationLat = "";
  String _string = "";
  String _destinationLong = "";
  String _deliveryType = "";
  String _destinationAddress = "";
  String _additionalInfo = "";
  String _scheduledTime = "";

  LocationModel? get location => _location;
  int? get quantityLiters => _quantityLiters;
  bool get loading => isLoading;

    // New getters for delivery details
  String get destinationLat => _destinationLat;
  String get destinationLong => _destinationLong;
  String get deliveryType => _deliveryType;
  String get destinationAddress => _destinationAddress;
  String get additionalInfo => _additionalInfo;
  String get scheduledTime => _scheduledTime;

  void changeLocation(LocationModel data) {
    _location = data;
    notifyListeners();
  }

  void changeLiters(int data) {
    _quantityLiters = data;
    notifyListeners();
  }

  void changeLoading(bool data) {
    isLoading = data;
    notifyListeners();
  }

  void changeDeliveryDetails({
    String? lat,
    String? long,
    String? deliveryType,
    String? address,
    String? additionalInfo,
    String? scheduledTime,
  }) {
    // Update each field only if the provided value is not null
 if (lat != null) _destinationLat = lat;
    if (long != null) _destinationLong = long;
    if (deliveryType != null) _deliveryType = deliveryType;
    if (address != null) _destinationAddress = address;
    if (additionalInfo != null) _additionalInfo = additionalInfo;
    if (scheduledTime != null) _scheduledTime = scheduledTime;

    // Notify listeners of the state change
    notifyListeners();
  }
}
