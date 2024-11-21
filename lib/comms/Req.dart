import 'dart:convert';

import 'package:application/Models/Tarrifs.dart';

import '../Models/DriverModel.dart';
import '../Models/TrucksModel.dart';
import '../Models/Wsp.dart';
import '../Models/Wsp_Orders.dart';
import 'comms_repo.dart';
import 'credentials.dart';
import '../main.dart';
import '../utils/utils.dart';
import '../views/state/appbloc.dart';
import '../views/widgets/WSP/homepage/WSPHomeScreen.dart';
import '../views/widgets/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../Models/Location.dart';
import '../Models/OrderModel.dart';

class AppRequest {
  static Future<List<OrderModel>> fetchOrders(bool isFp) async{
    final uri ="${base_url}${isFp?'fp/wsp-orders':' wsp/orders'}";
    
    final Map<String, dynamic> wspOrders = await comms_repo.queryApi(uri);
    if (wspOrders["success"]) {
      final data = wspOrders['data'] as List<dynamic>;

      return data.map((e) => OrderModel.fromJson(e)).toList();
    } else {
      throw Exception(wspOrders["message"]);
    }
  }


//  Drivers request
  static Future<List<Drivermodel>> fetchDrivers(
      {required bool isProfile}) async {
    final uri =
        isProfile ? "${base_url}drivers/profile" : "${base_url}fp/drivers";
    final Map<String, dynamic> drivers = await comms_repo.queryApi(uri);
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

  // using  a generic function comms_repo.queryApi for get requests
// fetch requests
  static Future<List<Trucksmodel>> fetchTrucks() async {
    final Map<String, dynamic> trucks =
        await comms_repo.queryApi("${base_url}fp/trucks");

    printLog("trucks RSP $trucks");

    if (trucks["success"]) {
      final data = trucks['data'] as List<dynamic>;
      return data.map((e) => Trucksmodel.fromJson(e)).toList();
    } else {
      return [];
      // throw Exception(trucks["message"]);
    }
  }

  static Future<List<LocationModel>> fetchLocations() {
    final locations = locationData
        .map((locations) => LocationModel.fromJson(locations))
        .toList();
    return Future.value(locations);
  }

  static Future<List<WsProviders>> fetchWSP() async {
    final Map<String, dynamic> wsp =
        await comms_repo.queryApi('${base_url}wsp/all');
    if (wsp["success"]) {
      final data = wsp['result'] as List<dynamic>;
      print("wspDetails---$data");
      return data.map((e) => WsProviders.fromJson(e)).toList();
    } else {
      print("Wsp error ${wsp["msg"]}");
      throw Exception(wsp["msg"]);
    }
  }

  static Future<List<TarrifsModel>> fetchWspTarrifs() async {
    printLog("\n\nfetchWSP_Orders called");
    final Map<String, dynamic> tarrifs =
        await comms_repo.queryApi('${base_url}wsp/tariffs');
    if (tarrifs["success"]) {
      print(tarrifs);
      print("success");
      print(tarrifs["data"]);

      if (tarrifs["data"] == null) {
        throw Exception(tarrifs["message"] );
      }

      final data = tarrifs['data'] as List<dynamic>;

      return data.map((e) => TarrifsModel.fromJson(e)).toList();
    } else {
      printLog("\n\n fetchWspTarrifs error ${tarrifs["msg"]}");

      throw Exception(tarrifs["message"]);
    }
  }

  

  static Future<List<OrderModel>> fetchWSP_Orders() async {
    printLog("\n\nfetchWSP_Orders called");
    final Map<String, dynamic> wspOrders =
        await comms_repo.queryApi('${base_url}fp/wsp-orders');
    if (wspOrders["success"]) {
      print("success");
      final data = wspOrders['data'] as List<dynamic>;
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } else {
      printLog("\n\nfetchWSP_Orders error ${wspOrders["msg"]}");

      throw Exception(wspOrders["message"]);
    }
  }

  static Future WSPSignup(
      {required BuildContext context,
      required Map<String, dynamic> data}) async {
    printLog("\n\nfetchWSP_Orders called");
    Appbloc blog = context.read<Appbloc>();
    final jsonString = jsonEncode(data);
    print("changing global loading state to true");
    blog.changeLoading(true);
    final Map<String, dynamic> signup = await comms_repo
        .QueryAPIpost('${base_url}users/register-service', jsonString,context);

    print("changing global loading state to false");
    blog.changeLoading(false);
    if (signup["success"]) {
      print("success");

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WSPHomeScreen()));
    } else {
      printLog("\n\singupWSP error ${signup["msg"]}");

      throw Exception(signup["message"]);
    }
  }
}
