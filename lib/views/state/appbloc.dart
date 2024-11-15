import '../../Models/Location.dart';
import 'package:flutter/material.dart';

class Appbloc extends ChangeNotifier {
  LocationModel? _location;
  int? _quantityLiters;
  bool isLoading=false;

  LocationModel? get location => _location;
  int? get quantityLiters => _quantityLiters;
  bool get loading => isLoading;

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
}
