
import 'package:application/views/widgets/Models/DriverModel.dart';
import 'package:application/views/widgets/Models/Location.dart';
import 'package:application/views/widgets/Models/OrderModel.dart';
import 'package:application/views/widgets/Models/TrucksModel.dart';
import 'package:application/views/widgets/globals.dart';

class AppRequest {
  static Future<List<Ordermodel>> fetchOrders() {
    final   orders =
        dummyData.map((orders) => Ordermodel.fromJson(orders)).toList();
    return Future.value(orders);
  }

static Future<List<drivermodel>> fetchDrivers() {
    final  drivers = driversDummy.map((drivers) => drivermodel.fromJson(drivers)).toList();
     return Future.value(drivers);
  }

  static Future<List<trucksmodel>> fetchTrucks() {
    final  trucks = dummyTrucksData.map((trucks) =>trucksmodel.fromJson(trucks)).toList();
     return Future.value(trucks);
  }


    static Future<List<LocationModel>> fetchLocations() {
    final  locations = locationData.map((locations) =>LocationModel.fromJson(locations)).toList();
     return Future.value(locations);
  }
  



}
