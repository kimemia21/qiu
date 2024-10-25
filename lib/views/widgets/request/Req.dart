
// import 'package:application/Models/DriverModel.dart';
// import 'package:application/Models/Drivermodel.dart';
import 'package:application/Models/DriverModel.dart';
import 'package:application/Models/OrderModel.dart';
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

// static Future<List<drivermodel>> fetchDrivers() {
//     final  drivers = driversDummy.map((drivers) => Drivermodel.fromJson(drivers)).toList();
// //     return Future.value(drivers);
//   }
}
