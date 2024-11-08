import 'package:application/Models/DriverModel.dart';
import 'package:application/Models/TrucksModel.dart';
import 'package:application/Models/Wsp.dart';
import 'package:application/Models/Wsp_Orders.dart';
import 'package:application/comms/comms_repo.dart';
import 'package:application/comms/credentials.dart';
import 'package:application/utils/utils.dart';
import 'package:application/views/widgets/globals.dart';

import '../Models/Location.dart';
import '../Models/OrderModel.dart';

class AppRequest {
  static Future<List<Ordermodel>> fetchOrders() {
    final orders =
        dummyData.map((orders) => Ordermodel.fromJson(orders)).toList();
    return Future.value(orders);
  }

//  Drivers request
  static Future<List<Drivermodel>> fetchDrivers({required bool isProfile}) async {
    final uri = isProfile
        ? "${base_url}drivers/profile"
        : "${base_url}fp/drivers";
    final Map<String, dynamic> drivers =
        await CommsRepository().queryApi(uri);
    if (drivers["success"]) {
      final data = drivers['data'] as List<dynamic>;

      return data.map((e) => Drivermodel.fromJson(e)).toList();
    } else {
      throw Exception(drivers["message"]);
    }


  }

//   static Future<List<Drivermodel>> fetchDrivers() async {
//   final List<Map<String, dynamic>> orders = [
//     {
//       "id": "ddfb7d98-6069-11ef-a99b-509a4c683487",
//       "firstName": "William",
//       "lastName": "Waweru",
//       "phone": "254123876543",
//       "assignedTruck": "KBC1234",
//       "driverFp": 1,
//       "isAvailable": 0
//     }
//   ];

//   final order = orders.map((order) => Drivermodel.fromJson(order)).toList();
//   return Future.value(order);
// }

        

  // using  a generic function CommsRepository().queryApi for get requests
// fetch requests
  static Future<List<Trucksmodel>> fetchTrucks() async {
    final Map<String, dynamic> trucks =
        await CommsRepository().queryApi("${base_url}fp/trucks");
    if (trucks["success"]) {
      final data = trucks['data'] as List<dynamic>;
      return data.map((e) => Trucksmodel.fromJson(e)).toList();
    } else {
      throw Exception(trucks["message"]);
    }
  }

  static Future<List<LocationModel>> fetchLocations() {
    final locations = locationData
        .map((locations) => LocationModel.fromJson(locations))
        .toList();
    return Future.value(locations);
  }

  static Future<List<WspModel>> fetchWSP() async {
    final Map<String, dynamic> wsp =
        await CommsRepository().queryApi('${base_url}wsp/all');
    if (wsp["rsp"]) {
      final data = wsp['result'] as List<dynamic>;
      return data.map((e) => WspModel.fromJson(e)).toList();
    } else {
      print("Wsp error ${wsp["msg"]}");
      throw Exception(wsp["msg"]);
    }
  }

  static Future<List<WspOrders>> fetchWSP_Orders() async {
    printLog("\n\nfetchWSP_Orders called");
    final Map<String, dynamic> wspOrders =
        await CommsRepository().queryApi('${base_url}fp/wsp-orders');
    if (wspOrders["success"]) {
      print("success");
      final data = wspOrders['data'] as List<dynamic>;
      return data.map((e) => WspOrders.fromJson(e)).toList();
    } else {
      printLog("\n\nfetchWSP_Orders error ${wspOrders["msg"]}");

      throw Exception(wspOrders["message"]);
    }
  }
}
