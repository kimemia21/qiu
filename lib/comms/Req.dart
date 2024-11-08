

import 'package:application/Models/DriverModel.dart';
import 'package:application/Models/Wsp.dart';
import 'package:application/Models/Wsp_Orders.dart';
import 'package:application/comms/comms_repo.dart';
import 'package:application/comms/credentials.dart';
import 'package:application/utils/utils.dart';
import 'package:application/views/widgets/globals.dart';



import '../Models/Location.dart';
import '../Models/OrderModel.dart';
import '../Models/TrucksModel.dart';

class AppRequest {
  static Future<List<Ordermodel>> fetchOrders() {
    final orders =
        dummyData.map((orders) => Ordermodel.fromJson(orders)).toList();
    return Future.value(orders);
  }
//  Drivers request 
  static Future<List<Drivermodel>> fetchDrivers() async {
    final Map<String, dynamic> drivers = await CommsRepository().queryApi("${base_url}fp/drivers");
    if (drivers["success"]) {
      final data = drivers['data'] as List<dynamic>;

      return data.map((e) => Drivermodel.fromJson(e)).toList();
    } else {
      throw Exception(drivers["message"]);
    }     

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

  // using  a generic function CommsRepository().queryApi for get requests
// fetch requests
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
