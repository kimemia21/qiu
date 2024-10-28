import 'package:application/views/widgets/Models/Location.dart';
import 'package:flutter/material.dart';

class Appbloc extends ChangeNotifier {
 LocationModel? _location;
  int? _quantityLiters;

 
LocationModel?  get  location => _location;
 int?  get quantityLiters => _quantityLiters;

  void changeLocation(LocationModel data) {
    _location = data;
    notifyListeners();
  }
    void changeLiters(int data) {
   _quantityLiters = data;
    notifyListeners();
  }
}
