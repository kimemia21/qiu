import 'dart:convert';
import 'dart:io';
import 'package:application/comms/Req.dart';
import 'package:application/views/state/appbloc.dart';
import 'package:flutter/material.dart';

import '../Models/OrderModel.dart';
import 'package:dio/dio.dart';
import 'package:get/state_manager.dart';

import '../Models/user.dart';
import '../Models/walletmodel.dart';
import '../utils/utils.dart';
import 'credentials.dart';
import 'package:provider/provider.dart';

class CommsRepository {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    baseUrl: base_url,
    followRedirects: false,
    // queryParameters: {"server_index": currentAccount.serverIndex},
    receiveTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 30),
    responseType: ResponseType.json,
    contentType: ContentType.json.toString(),
  ));
  final _baseUrl = base_url;

  // Stream<RequestsModel> getrequests({required userid}) async* {
  //   RequestsModel req;

  //   while (true) {
  //     //loop from response
  //     req = RequestsModel();
  //     yield req;
  //   }
  // }

// {
//   "status": true,
//   "message": "Registration successfull",
//   "status_code": 200,
//   "data": {
//     "id": "45a807ad-cdb2-4609-a962-14e9d6f7e49a",
//     "first_name": "Evans",
//     "last_name": "kuria",
//     "mobile_number": "0721374510",
//     "email": "evahnc@live.com",
//     "user_type": "Admin",
//     "member_type": "Community",
//     "country": "Kenya",
//     "date_created": "2023-01-08T23:47:02.072471+03:00",
//     "updated_on": "2023-01-08T23:47:02.072440+03:00",
//     "comments": []
//   }
// }

  Future<mpesaRequest?> paymentRequest(int due, phone, Pocket wallet) async {
    var requestpayload = {
      "user_email": currentIndexUser.userEmail,
      "transaction_date": DateTime.now().toString(),
      "phone": phone,
      "destination_pocket": wallet.pocketName,
      "destination_pocket_id": wallet.pocketId,
      "gate_name": wallet.pocketName,
      "amount": due,
      "currency": wallet.currency,
    };

    printLog("request Mpesa ${(due.round()).toString()}, $phone");
    try {
      Response response = await _dio
          .post(
            '/reqpocketmpesa',
            data: requestpayload,
          )
          .timeout(const Duration(seconds: 30));
      printLog(
          "\n\nGot Mpesa Rsponsse ${response.statusCode}  ${response.data}");
      //Currently Unavailable

      return mpesaRequest.fromMap(response.data);
    } on DioError catch (e) {
      printLog("makeMpesaPayment Query Error ${e.message.toString()}");
    } catch (e) {
      printLog('makeMpesaPayment Error 3_--------- ${e.toString()}');
    }
    return mpesaRequest(bool_code: false, message: "Unable to Process");
  }

  Future<Map<String, dynamic>> getLandlordStatus() async {
    var pload = {
      "registration_id": 0,
      "landlord_id": current_user.id,
      "date_from": dateformartnotime
          .format(DateTime.now().add(const Duration(days: -30))),
      "date_to":
          dateformartnotime.format(DateTime.now().add(const Duration(days: 1))),
    };

    printLog("Request landlord status " + _baseUrl + 'landlordstats');
    try {
      Response response = await _dio.post('${_baseUrl}landlordstats',
          data: pload // FormData.fromMap(pload),
          // options:
          // new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))
          );
      printLog("Landlord response ${response.data}");

      return response.data;
    } on DioError catch (e) {
      printLog(" Dio Error ${e.message.toString()} ${e.error} ${e.response}");
      // if (e.message.toString().contains("host"))
      // return {"status": false, "msg": "No Internet Connection."};
      // if (e.response!.statusCode == 409) {
      //   return {"status": "Some other error."};
      // }
    } catch (e) {
      printLog('  e Error ${e.toString()}');
    }

    return {};
  }

  Future<Map<String, dynamic>> MpesaPaymentStatus(ref) async {
    var pload = {
      "trans_no": ref,
    };

    printLog("Request mpesa status ");
    try {
      Response response = await _dio.post('/reqpocketstatus',
          data: pload // FormData.fromMap(pload),
          // options:
          // new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))
          );
      printLog("mpesa status response ${response.data}");

      return response.data;
    } on DioError catch (e) {
      printLog(" Dio Error ${e.message.toString()} ${e.error} ${e.response}");
      // if (e.message.toString().contains("host"))
      // return {"status": false, "msg": "No Internet Connection."};
      // if (e.response!.statusCode == 409) {
      //   return {"status": "Some other error."};
      // }
    } catch (e) {
      printLog('  e Error ${e.toString()}');
    }

    return {"bool_code": false, "message": "Unable to process"};
  }

  Future<bool> createPocket(pocketname) async {
    var pload = {
      "user_email": currentIndexUser.userEmail,
      "user_password": currentIndexUser.userPass,
      "pocket_name": pocketname,
      "app_gate": app_gate
    };

    printLog("Request create newpocket ");
    try {
      Response response = await _dio.post('/newpocket',
          data: pload // FormData.fromMap(pload),
          // options:
          // new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))
          );
      printLog(" response ${response.data}");
      return true;

      return response.data;
    } on DioError catch (e) {
      printLog(" Dio Error ${e.message.toString()} ${e.error} ${e.response}");
      // if (e.message.toString().contains("host"))
      // return {"status": false, "msg": "No Internet Connection."};
      // if (e.response!.statusCode == 409) {
      //   return {"status": "Some other error."};
      // }
    } catch (e) {
      printLog('  e Error ${e.toString()}');
    }

    return false;
  }

  Future<bool> Report(Ordermodel? meter, String issue) async {
    var pload = {
      "meter_id": meter == null ? "-1" : meter.id,
      "meter_number": meter == null ? "" : meter.name,
      "issue": issue,
      "user_id": current_user.id,
      "is_landlord": current_user.islandlord ? 1 : 0
    };

    printLog("Request Post Issue ");
    try {
      Response response = await _dio.post('/report',
          data: pload // FormData.fromMap(pload),
          // options:
          // new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))
          );
      printLog(" response ${response.data}");
      return true;
    } on DioError catch (e) {
      printLog(" Dio Error ${e.message.toString()} ${e.error} ${e.response}");
      // if (e.message.toString().contains("host"))
      // return {"status": false, "msg": "No Internet Connection."};
      // if (e.response!.statusCode == 409) {
      //   return {"status": "Some other error."};
      // }
    } catch (e) {
      printLog('  e Error ${e.toString()}');
    }

    return false;
  }

  Future<Map<String, dynamic>> getCustomerDetails(otp) async {
    var pload = {
      "otp": otp,
    };
    // _dio.options.headers["x-access-token"] = current_user.access_token;

    printLog("Request Customer " + _baseUrl + 'customerDetails.php   otp $otp');
    try {
      Response response = await _dio.post(
        '${_baseUrl}customerDetails.php',
        data: FormData.fromMap(pload),
        // options:
        // new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))
      );
      printLog("custoemr details response ${response.data}");

      if (response.statusCode == 200) {
        if (response.data.toString().contains("I HAVE NOTHING")) {
          return {
            "status": false,
            "msg": "Unable to process",
            "data": response.data
          };
        } else {
          return {"status": true, "msg": "Got Data", "data": response.data};
        }
      }
      return {
        "status": true,
        "msg": "Unable to process",
        "data": response.data
      };
    } on DioError catch (e) {
      printLog(" Error ${e.message.toString()} ${e.error} ${e.response}");
      if (e.message.toString().contains("host")) {
        return {"status": true, "msg": "No Internet Connection."};
      }
      // if (e.response!.statusCode == 409) {
      //   return {"status": "Some other error."};
      // }
    } catch (e) {
      printLog('  ae Error ${e.toString()}');
    }

    return {"status": true, "msg": "Some other error."};
  }

  Future<Map<dynamic, dynamic>> getTenantTokenBalance(
      meterid, DateTime from, DateTime till) async {
    var pload = {
      "meter_id": meterid,
      "date_from": from.toString().substring(0, 10),
      "date_to": till.toString().substring(0, 10),
    };

    List<double> usage = [];
    printLog('''l 
        $meterid 
         tokensbal \npload ${jsonEncode(pload)}''');
    try {
      Response response = await _dio
          .post('tokensbal', data: pload // FormData.fromMap(pload),
              // options:
              // new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))
              )
          .timeout(const Duration(seconds: 60));

      return response.data["data"][0];
    } on DioError catch (e) {
      printLog(" Error ${e.message.toString()} ${e.error} ${e.response}");
      if (e.message.toString().contains("host")) {
        return {"status": false, "msg": "No Internet Connection."};
      }
      // if (e.response!.statusCode == 409) {
      //   return {"status": "Some other error."};
      // }
    } catch (e) {
      printLog('  be Error ${e.toString()}');
    }

    return {"status": false, "msg": "Some other error."};
  }

  Future<List<WalletTransaction>> getWalletTransactions() async {
    List<WalletTransaction> wtransactions = [];

    var paylaod = {
      "request": 1,
      "user_email": currentIndexUser.userEmail,
      "date_from": dateformartnotime
          .format(DateTime.now().add(const Duration(days: -30))),
      "date_to":
          dateformartnotime.format(DateTime.now().add(const Duration(days: 1))),
      "trx_type": "ALL"
    };
    printLog("Get wallet transactions $paylaod");
    try {
      Response response = await _dio.post('wallettrans', data: paylaod
          // options:
          // new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))
          );
      // .timeout(const Duration(seconds: 80));

      printLog("got wallert data");
      printLog("Got Respossne ${response.data}");

      // Map<String, dynamic> jsonMap = json.decode(response.data);
      List<WalletTransaction> transactions = (response.data['transactions']
              as List)
          .map((transactionJson) => WalletTransaction.fromJson(transactionJson))
          .toList();
      wtransactions = transactions;
      printLog("transactions ${wtransactions.length}");
    } on DioError catch (e) {
      printLog(" Error ${e.message.toString()} ${e.error} ${e.response}");
      if (e.message.toString().contains("host")) return [];
      // if (e.response!.statusCode == 409) {
      //   return {"status": "Some other error."};
      // }
    } catch (e) {
      printLog('  e Error ${e.toString()}');
    }

    return wtransactions;
  }

  Future<Map<dynamic, dynamic>> makePayment(phoneno, int amt) async {
    var payload = {
      "phone": phoneno,
      "amount": amt,
      "account": phoneno,
      "token": current_user.access_token
    };
    // _dio.options.headers["x-access-token"] = current_user.access_token;

    printLog("Request purchase " +
        current_user.phone_number +
        " amt $amt" +
        'https://jaribu.earthview.co.ke/Camea/Beta_api/stk_demo.php');
    try {
      Response response = await _dio.post(
        'https://jaribu.earthview.co.ke/Camea/Beta_api/stk_demo.php',
        data: FormData.fromMap(payload),
        // options:
        // new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))
      );
      printLog("purchase response ${response.data}");
      if (response.statusCode == 200) {
        return {"status": true, "msg": response.data};
      } else {
        return {"status": false, "msg": response.data};
      }
    } on DioError catch (e) {
      printLog(" Error ${e.message.toString()} ${e.error} ${e.response}");
      if (e.message.toString().contains("host")) {
        return {"status": false, "msg": "No Internet Connection."};
      }
      // if (e.response!.statusCode == 409) {
      //   return {"status": "Some other error."};
      // }
    } catch (e) {
      printLog('  ee Error ${e.toString()}');
    }

    return {"status": false, ",msg": "Some other error."};
  }

  Future<Map<dynamic, dynamic>> requestOtp(phoneno) async {
    userModel? loginResponse;

    var loginPayload = {"phone_no": phoneno, "registration_id": 0};
    // _dio.options.headers["x-access-token"] = current_user.access_token;

    printLog("Request otp $phoneno $_baseUrl otp");
    try {
      Response response = await _dio
          .post(
            '${_baseUrl}otp',
            data: loginPayload,
            // options:
            // new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))
          )
          .timeout(const Duration(seconds: 30));
      printLog("otp response ${response.data}");
      return response.data[0];
    } on DioError catch (e) {
      printLog(" Error ${e.message.toString()} ${e.error} ${e.response}");
      if (e.message.toString().contains("Connecting timed out ")) {
        return {"rsp": false, "msg": "Timed out\nPlease check connection."};
      }

      // if (e.response!.statusCode == 500)
      //   return {"rsp": false, "msg": e.response!.data["msg"]};
      if (e.message.toString().contains("host") ||
          e.message.toString().contains("Network is unreachable")) {
        return {"rsp": false, "msg": "No Internet Connection."};
      }
      // if (e.response!.statusCode == 409) {
      //   return {"status": "Some other error."};
      // }
    } catch (e) {
      printLog('  e Error ${e.toString()}');
    }

    return {"rsp": false, "msg": "Got some Error"};
  }

  Future<Map<String, dynamic>> walletsRegister() async {
    var payload = {
      "user_name": currentIndexUser.userName,
      "user_email": currentIndexUser.userEmail,
      "user_pass": currentIndexUser.userPass,
      "phone_no": currentIndexUser.userPhone
    };
    // _dio.options.headers["x-access-token"] = current_user.access_token;
    printLog("indx register Paylaod $payload");
    try {
      Response response = await _dio
          .post(
            'indexregister',
            data: payload,
            // options:
            // new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))
          )
          .timeout(const Duration(seconds: 30));
      printLog("Index REgister response ${response.statusCode}");

      printLog("Index REgister response ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        printLog("Index REgister response ${response.data}");
        printLog("Index REgister response ${response.data}");
      }
    } on DioException catch (e) {
      printLog(" Error dd ${e.message.toString()} ${e.error} ${e.response}");
      if (e.response != null) {
        if (e.response!.statusCode == 501) {
          return {"rsp": false, "msg": "Account already Exists"};
        }
      }

      if (e.message.toString().contains("Connecting timed out ")) {
        return {"rsp": false, "msg": "Timed out\nPlease check connection."};
      }

      // if (e.response!.statusCode == 500)
      //   return {"rsp": false, "msg": e.response!.data["msg"]};
      if (e.message.toString().contains("host") ||
          e.message.toString().contains("Network is unreachable")) {
        return {"rsp": false, "msg": "No Internet Connection."};
      }
      // if (e.response!.statusCode == 409) {
      //   return {"status": "Some other error."};
      // }
    } catch (e) {
      printLog(' d e Error ${e.toString()}');
    }

    return {"rsp": false, "msg": "Got error Registering"};
  }

  Future<Map<String, dynamic>> walletsLogin() async {
    var payload = {
      "user_name": currentIndexUser.userName,
      "user_email": currentIndexUser.userEmail,
      "user_pass": currentIndexUser.userPass,
      "phone_no": currentIndexUser.userPhone
    };
    // _dio.options.headers["x-access-token"] = current_user.access_token;

    try {
      Response response = await _dio
          .post(
            'indexlogin',
            data: payload,
            // options:
            // new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))
          )
          .timeout(const Duration(seconds: 30));
      printLog("Index wallets response ${response.statusCode}");

      printLog("Index wallets response ${response.data}");
      if (response.statusCode == 200) {
        return response.data;
      } else {
        printLog("Index wallets response ${response.data}");
        printLog("Index wallets response ${response.data}");
      }
    } on DioException catch (e) {
      printLog(" Error dd ${e.message.toString()} ${e.error} ${e.response}");

      if (e.response!.statusCode == 409) {
        return {"rsp": false, "msg": "Invalid Credentials!"};
      }
      if (e.message.toString().contains("Connecting timed out ")) {
        return {"rsp": false, "msg": "Timed out\nPlease check connection."};
      }

      // if (e.response!.statusCode == 500)
      //   return {"rsp": false, "msg": e.response!.data["msg"]};
      if (e.message.toString().contains("host") ||
          e.message.toString().contains("Network is unreachable")) {
        return {"rsp": false, "msg": "No Internet Connection."};
      }
      // if (e.response!.statusCode == 409) {
      //   return {"status": "Some other error."};
      // }
    } catch (e) {
      printLog(' d e Error ${e.toString()}');
    }

    return {"rsp": false, "msg": "Got some Error"};
  }

  Future<Map<dynamic, dynamic>> withdraw(Pocket pocket, amount) async {
    var payload = {
      "user_email": currentIndexUser.userEmail,
      "user_pass": currentIndexUser.userPass,
      "phone_no": currentIndexUser.userPhone,
      "transaction_date": dateformartwithtime.format(DateTime.now()),
      "transaction_intent": 'Withdraw',
      "phone": currentIndexUser.userPhone,
      "destination_phone": currentIndexUser.userPhone,
      // destination_paybill: req.body.destination_paybill,
      "amount": amount,
      "currency": pocket.currency,
      "pocket_id": pocket.pocketId,
      "accountBalance": pocket.accountBalance,
      "pocket_gate": pocket.gate,
    };

    // _dio.options.headers["x-access-token"] = current_user.access_token;

    try {
      Response response = await _dio
          .post(
            'withdraw',
            data: payload,
            // options:
            // new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))
          )
          .timeout(const Duration(seconds: 30));
      printLog("Index withdraw response ${response.data}");
      return response.data;
    } on DioError catch (e) {
      printLog(" Error msg ${e.message.toString()} ${e.error} ${e.response}");

      if (e.response != null) {
        //      if (e.response!.data is String) {
        // // Parse the JSON data
        // Map<String, dynamic> data = json.decode(response.body);

        return e.response!.data as Map<dynamic, dynamic>;
      }
      if (e.message.toString().contains("Connecting timed out ")) {
        return {"rsp": false, "msg": "Timed out\nPlease check connection."};
      }

      // if (e.response!.statusCode == 500)
      //   return {"rsp": false, "msg": e.response!.data["msg"]};
      if (e.message.toString().contains("host") ||
          e.message.toString().contains("Network is unreachable")) {
        return {"rsp": false, "msg": "No Internet Connection."};
      }
      // if (e.response!.statusCode == 409) {
      //   return {"status": "Some other error."};
      // }
    } catch (e) {
      printLog('  e Error ${e.toString()}');
    }

    return {"rsp": false, "msg": "Got some Error"};
  }

  Future<Map<String, dynamic>> QueryAPIpost(String endpoint, jsonstring, BuildContext context) async {
    printLog(
        "QueryAPIpost $base_url$endpoint $jsonstring, ${current_user!.access_token!} ");

 Appbloc blog = context.read<Appbloc>();

  

    try {
      
      blog.changeLoading(true);
      if (!(endpoint == "login" ||
          endpoint == 'users/register-service' ||
          endpoint == "register" ||
          endpoint == "otp")) {
        _dio.options.headers['Authorization'] =
            'Bearer ${current_user!.access_token!}';
      } else {
        printLog("Hit $base_url to $endpoint $jsonstring");
      }

      printLog("Hit $base_url to $endpoint $jsonstring");

      Response response = await _dio.post("$endpoint", data: jsonstring);
      printLog("Response sttaus code ${response.statusCode}");
      
      blog.changeLoading(false);

      if (response.statusCode == 200) {
        return response.data;
      }
      if (response.statusCode == 201) {
        return response.data;
      }
      if (response.statusCode == 401 || response.statusCode == 403) {
        printLog("Logout. Sesion Expired");

        //    Get.to(const Logout());
      }
      if (response.statusCode == 200) {
        return response.data;
      }
      // return {"rsp": false, "mess
      //age": "Unable to process"};
    } on DioException catch (e) {
      
      blog.changeLoading(false);
      // printLog("$e");

      if (e.response != null) {
        printLog("Response sttaus code ${e.response!.statusCode}");

        printLog("my new e ${e.response}");
        printLog("my new ersp ${e.response!.data}");
        return e.response!.data as Map<String, dynamic>;
      }
      if (e.error != null) {
        printLog("my new e ${e.response}");
        printLog("my new ersp ${e.response!.data}");
        return e.response!.data as Map<String, dynamic>;
      }
      printLog(
          " Error ${e.message.toString()} erro ${e.error}  rsp ${e.response}");

      if (e.error.toString().contains("Connection refused")) {
        return {"rsp": false, "message": "Unable to contact the server."};
      }
      if (e.error.toString().contains("host") ||
          e.error.toString().contains("unreachable")) {
        return {"rsp": false, "message": "No Internet Connection."};
      }
      if (e.response!.statusCode == 409) {
        return {
          "rsp": false,
          "message": "Sorry, Phone or Email already in Use"
        };
      }
    } catch (e) {
      // printLog(e);

      printLog('24e  ae Error ${e.toString()}');
    }

    return {"rsp": false, "message": "Unable to Process Request."};
  }

  Future<Map<String, dynamic>> QueryAPIPatch(
      String endpoint, jsonstring, BuildContext context) async {
    printLog(
        "QueryAPIpost $base_url$endpoint $jsonstring, ${current_user!.access_token!} ");
    Appbloc blog = context.read<Appbloc>();
    try {
      blog.changeLoading(true);
      if (!(endpoint == "login" ||
          endpoint == 'users/register-service' ||
          endpoint == "register" ||
          endpoint == "otp")) {
        _dio.options.headers['Authorization'] =
            'Bearer ${current_user!.access_token!}';
      } else {
        printLog("Hit $base_url to $endpoint $jsonstring");
      }

      printLog("Hit $base_url to $endpoint $jsonstring");

      Response response = await _dio.patch("$endpoint", data: jsonstring);
      printLog("Response sttaus code ${response.statusCode}");
      
      blog.changeLoading(false);

      if (response.statusCode == 200) {
        return response.data;
      }
      if (response.statusCode == 201) {
        return response.data;
      }
      if (response.statusCode == 401 || response.statusCode == 403) {
        printLog("Logout. Sesion Expired");

        //    Get.to(const Logout());
      }
      if (response.statusCode == 200) {
        return response.data;
      }
      // return {"rsp": false, "message": "Unable to process"};
    } on DioException catch (e) {
      // printLog("$e");

      blog.changeLoading(false);
      if (e.response != null) {
        printLog("Response sttaus code ${e.response!.statusCode}");

        printLog("my new e ${e.response}");
        printLog("my new ersp ${e.response!.data}");
        return e.response!.data as Map<String, dynamic>;
      }
      if (e.error != null) {
        printLog("my new e ${e.response}");
        printLog("my new ersp ${e.response!.data}");
        return e.response!.data as Map<String, dynamic>;
      }
      printLog(
          " Error ${e.message.toString()} erro ${e.error}  rsp ${e.response}");

      if (e.error.toString().contains("Connection refused")) {
        return {"rsp": false, "message": "Unable to contact the server."};
      }
      if (e.error.toString().contains("host") ||
          e.error.toString().contains("unreachable")) {
        return {"rsp": false, "message": "No Internet Connection."};
      }
      if (e.response!.statusCode == 409) {
        return {
          "rsp": false,
          "message": "Sorry, Phone or Email already in Use"
        };
      }
    } catch (e) {
      // printLog(e);

      printLog('24e  ae Error ${e.toString()}');
    }

    return {"rsp": false, "message": "Unable to Process Request."};
  }


  Future<Map<String, dynamic>> QueryAPIDelete(
      String endpoint, BuildContext context) async {
    printLog(
        "QueryAPIpost $base_url$endpoint ${current_user!.access_token!} ");
    Appbloc blog = context.read<Appbloc>();
    try {
      blog.changeLoading(true);
      if (!(endpoint == "login" ||
          endpoint == 'users/register-service' ||
          endpoint == "register" ||
          endpoint == "otp")) {
        _dio.options.headers['Authorization'] =
            'Bearer ${current_user!.access_token!}';
      } else {
        printLog("Hit $base_url to $endpoint ");
      }

      printLog("Hit $base_url to $endpoint ");

      Response response = await _dio.delete("$endpoint",);
      printLog("Response sttaus code ${response.statusCode}");
      
      blog.changeLoading(false);

      if (response.statusCode == 200) {
        return response.data;
      }
      if (response.statusCode == 201) {
        return response.data;
      }
      if (response.statusCode == 401 || response.statusCode == 403) {
        printLog("Logout. Sesion Expired");

        //    Get.to(const Logout());
      }
      if (response.statusCode == 200) {
        return response.data;
      }
      // return {"rsp": false, "message": "Unable to process"};
    } on DioException catch (e) {
      // printLog("$e");

      blog.changeLoading(false);
      if (e.response != null) {
        printLog("Response sttaus code ${e.response!.statusCode}");

        printLog("my new e ${e.response}");
        printLog("my new ersp ${e.response!.data}");
        return e.response!.data as Map<String, dynamic>;
      }
      if (e.error != null) {
        printLog("my new e ${e.response}");
        printLog("my new ersp ${e.response!.data}");
        return e.response!.data as Map<String, dynamic>;
      }
      printLog(
          " Error ${e.message.toString()} erro ${e.error}  rsp ${e.response}");

      if (e.error.toString().contains("Connection refused")) {
        return {"rsp": false, "message": "Unable to contact the server."};
      }
      if (e.error.toString().contains("host") ||
          e.error.toString().contains("unreachable")) {
        return {"rsp": false, "message": "No Internet Connection."};
      }
      if (e.response!.statusCode == 409) {
        return {
          "rsp": false,
          "message": "Sorry, Phone or Email already in Use"
        };
      }
    } catch (e) {
      // printLog(e);

      printLog('24e  ae Error ${e.toString()}');
    }

    return {"rsp": false, "message": "Unable to Process Request."};
  }

// here
  Future<Map<String, dynamic>> queryApi(endpoint,
      [String filterquery = ""]) async {
    printLog(' Get $base_url "$endpoint$filterquery"}');

    try {
      _dio.options.headers['Authorization'] =
          'Bearer ${current_user.access_token}';

      Response response = await _dio.get("$endpoint$filterquery");
      printLog("get $endpoint response ${response.statusCode}");
      if (response.statusCode == 200) {
        return response.data;
      }
      if (response.statusCode == 401 || response.statusCode == 403) {
        printLog("Logout. Sesion Expired");

        // Get.to(const Logout());
      }
      return {"rsp": false, "message": "Unable to process"};
    } on DioException catch (e) {
      printLog("\nDio Error ${e.message.toString()} ${e.error} ${e.response}");
      if (e.response != null) {
        if (e.response!.statusCode == 401 || e.response!.statusCode == 403) {
          printLog("Logout. Sesion Expired");

          //  Get.to(const Logout());
        }
      }

      if (e.error.toString().contains("host") ||
          e.error.toString().contains("unreachable")) {
        return {"rsp": false, "message": "No Internet Connection."};
      }
      if (e.error.toString().contains("Connection refused")) {
        return {"rsp": false, "message": "Unable to reach Server."};
      }

      // if (e.response!.statusCode == 409) {
      //   return {"status": "Unable to Process Request."};
      // }
    } catch (e) {
      printLog(' \n Query Api ae Error ${e.toString()}');
    }

    return {"rsp": false, "message": "Unable to Process Request."};
  }

// pay_to_merchant_pocket
// pay_to_merchant_gate
  Future<Map<String, dynamic>> payByIndX(
      Pocket pocket, Ordermodel? order, amount, trans_desc) async {
//     var payload = {
//       "merchant_id": order.pay_to_merchant_gate,
//       "meter_id": order.id,
//       "meter_serial": order.name,
//       "user_email": currentIndexUser.userEmail,
//       "user_password": currentIndexUser.userPass,
//       "transaction_date": DateTime.now().toString(),
//       "source_pocket": pocket.pocketName,
//       "destination_pocket": order.pay_to_merchant_pocket,
//       "source_pocket_id": pocket.pocketId,
//       "destination_pocket_id": meter.landlord_id,
//       "gate_name": meter.pay_to_merchant_gate,
//       "amount": amount,
//       "currency": pocket.currency,
//       "pay_reason": trans_desc,
//       "user_id": current_user.id,
//       "meter_number": current_user.defaultmeter!.meter_number,
//       "can_auto_load_tokens":
//           current_user.defaultmeter!.can_auto_load_tokens ?? false,
//       "get_token": current_user.defaultmeter!.metertype
//           .toString()
//           .toLowerCase()
//           .contains("pre")
//     };
//     // _dio.options.headers["x-access-token"] = current_user.access_token;

//     try {
//       Response response = await _dio
//           .post(
//             'pocketpay',
//             data: payload,
//             // options:
//             // new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))
//           )
//           .timeout(const Duration(seconds: 120));
//       printLog("Pay by indx Response ${response.data}");
//       return response.data;

//       // if (response.statusCode == 200) {
//       //   return response.data;
//       // } else if (response.data["status"] != null) {
//       //   return response.data;
//       // }
//     } on DioError catch (e) {
//       printLog(" Error ${e.message.toString()} ${e.error} ${e.response}");
//       if (e.message.toString().contains("Connecting timed out "))
//       // return {"rsp": false, "msg": "Timed out\nPlease check connection."};

//       // if (e.response!.statusCode == 500)
//       //   return {"rsp": false, "msg": e.response!.data["msg"]};
//       if (e.message.toString().contains("host") ||
//           e.message.toString().contains("Network is unreachable")) {
//         printLog("No internet");
//       }
//       // return {"rsp": false, "msg": "No Internet Connection."};
//       // if (e.response!.statusCode == 409) {
//       //   return {"status": "Some other error."};
//       // }
//     } catch (e) {
//       printLog('  e Error ${e.toString()}');
//     }
// //
    return {"status": false, "message": "Unable to Post Payment"};
  }

  Future<List<Pocket>?> FetchWallets() async {
    var payload = {
      "user_name": currentIndexUser.userName,
      "user_email": currentIndexUser.userEmail,
      "user_pass": currentIndexUser.userPass,
      "phone_no": currentIndexUser.userPhone,
      "islandlord": current_user.islandlord
    };
    // _dio.options.headers["x-access-token"] = current_user.access_token;

    printLog("FetchWallets $payload");

    try {
      Response response = await _dio
          .post(
            'getwallets',
            data: payload,
            // options:
            // new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        // Map<String, dynamic> jsonMap = json.decode(value.toString());
        PocketsResponse pocketsResponse =
            PocketsResponse.fromJson(response.data);

        currentIndexUser.wallets = pocketsResponse.pockets;
        return currentIndexUser.wallets!;
      }
    } on DioError catch (e) {
      printLog(" Error ${e.message.toString()} ${e.error} ${e.response}");
      if (e.message.toString().contains("Connecting timed out "))
      // return {"rsp": false, "msg": "Timed out\nPlease check connection."};

      // if (e.response!.statusCode == 500)
      //   return {"rsp": false, "msg": e.response!.data["msg"]};
      if (e.message.toString().contains("host") ||
          e.message.toString().contains("Network is unreachable")) {
        printLog("No internet");
      }
      // return {"rsp": false, "msg": "No Internet Connection."};
      // if (e.response!.statusCode == 409) {
      //   return {"status": "Some other error."};
      // }
    } catch (e) {
      printLog('  e Error ${e.toString()}');
    }

    // return {"rsp": false, "msg": "Got some Error"};

    return null;
  }

  Future<Map<dynamic, dynamic>> loginUser(email, pass) async {
    userModel? loginResponse;

    var loginPayload = {
      "user_name": email,
      "pass_word": pass,
    };
    // _dio.options.headers["x-access-token"] = current_user.access_token;

    printLog("Request login $email " + _baseUrl + '');
    try {
      Response response = await _dio
          .post(
            'login',
            data: loginPayload,
            // options:
            // new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))
          )
          .timeout(const Duration(seconds: 30));
      printLog("USER LOGIN response ${response.data}");
      return response.data;
    } on DioError catch (e) {
      printLog(" Error ${e.message.toString()} ${e.error} ${e.response}");
      if (e.message.toString().contains("Connecting timed out ")) {
        return {
          "active": false,
          "user_status": "Timed out\nPlease check connection."
        };
      }

      if (e.message.toString().contains("onnection refused")) {
        return {
          "active": false,
          "user_status": "Unreachable\nUnable to reach server."
        };
      }

      // if (e.response!.statusCode == 500)
      //   return {"rsp": false, "msg": e.response!.data["msg"]};
      if (e.message.toString().contains("host") ||
          e.message.toString().contains("is unreachable")) {
        return {"active": false, "user_status": "No Internet Connection."};
      }
      // if (e.response!.statusCode == 409) {
      //   return {"status": "Some other error."};
      // }
    } catch (e) {
      printLog('  e Error ${e.toString()}');
    }

    return {"active": false, "user_status": "Unable to Process"};
  }

  Future<List<Pocket>?> indexLogin() async {
    var payload = {
      "user_name": currentIndexUser.userName,
      "user_email": currentIndexUser.userEmail,
      "user_pass": currentIndexUser.userPass,
      "phone_no": currentIndexUser.userPhone
    };
    // _dio.options.headers["x-access-token"] = current_user.access_token;

    try {
      Response response = await _dio
          .post(
            'indexlogin',
            data: payload,
            // options:
            // new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        // Map<String, dynamic> jsonMap = json.decode(value.toString());
        PocketsResponse pocketsResponse =
            PocketsResponse.fromJson(response.data);

        currentIndexUser.wallets = pocketsResponse.pockets;
        return currentIndexUser.wallets!;
      } else {
        printLog("REsponse ${response.statusCode}");
        printLog("REsponse Data ${response.data}");
      }
    } on DioException catch (e) {
      printLog(" Error xx ${e.message.toString()} ${e.error} ${e.response}");
      if (e.message.toString().contains("Connecting timed out "))
      // return {"rsp": false, "msg": "Timed out\nPlease check connection."};
      // if (e.response!.statusCode == 500)
      //   return {"rsp": false, "msg": e.response!.data["msg"]};
      if (e.message.toString().contains("host") ||
          e.message.toString().contains("Network is unreachable")) {
        printLog("No internet");
      }
      // return {"rsp": false, "msg": "No Internet Connection."};
      // if (e.response!.statusCode == 409) {
      //   return {"status": "Some other error."};
      // }
    } catch (e) {
      printLog('  e Error ${e.toString()}');
    }

    // return {"rsp": false, "msg": "Got some Error"};

    return null;
  }

  Future<bool> pingServer() async {
    printLog("TRY PING SERVER");
    try {
      Response response = await _dio
          .get(
            'ping',
            // options:
            // new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))
          )
          .timeout(const Duration(seconds: 15));
      printLog(" Ping response ${response.data}");
      return response.statusCode == 200;
    } on DioError catch (e) {
      printLog(" Error ${e.message.toString()} ${e.error} ${e.response}");
    } catch (e) {
      printLog('  e Error ${e.toString()}');
    }
    return false;
  }
}
