import 'package:application/views/widgets/globals.dart';

import '../Models/DriverModel.dart';
import '../Models/Location.dart';
import '../Models/OrderModel.dart';
import '../Models/TrucksModel.dart';

class AppRequest {
  static Future<List<Ordermodel>> fetchOrders() {
    final orders =
        dummyData.map((orders) => Ordermodel.fromJson(orders)).toList();
    return Future.value(orders);
  }

  static Future<List<drivermodel>> fetchDrivers() {
    final drivers =
        driversDummy.map((drivers) => drivermodel.fromJson(drivers)).toList();
    return Future.value(drivers);
  }

  static Future<List<trucksmodel>> fetchTrucks() {
    final trucks =
        dummyTrucksData.map((trucks) => trucksmodel.fromJson(trucks)).toList();
    return Future.value(trucks);
  }

  static Future<List<LocationModel>> fetchLocations() {
    final locations = locationData
        .map((locations) => LocationModel.fromJson(locations))
        .toList();
    return Future.value(locations);
  }
}
