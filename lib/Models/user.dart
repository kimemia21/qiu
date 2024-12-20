import 'dart:convert';
import 'dart:ffi';

import '../comms/credentials.dart';
import '../utils/utils.dart';
import 'walletmodel.dart';

class IndexUserModel {
  String? userName;
  String? userEmail;
  String? userPass;
  String? userPhone;
  String? gateName;
  bool? active;
  List<Pocket>? wallets = [];

  IndexUserModel(
      {this.userName,
      this.active,
      this.userEmail,
      this.userPass,
      this.gateName,
      this.userPhone});

  factory IndexUserModel.fromJson(Map<String, dynamic> json) => IndexUserModel(
      userName: json["user_name"],
      active: json["active"] == 1,
      userPass: json["user_pass"],
      userEmail: json["user_email"],
      gateName: json["gate_name"],
      userPhone: json["user_phone"]);

  Map<String, dynamic> toJsonMap() => {
        "user_name": userName,
        "user_email": userEmail,
        "active": active! ? 1 : 0,
        "gate_name": gateName,
        "user_pass": userPass,
        "user_phone": userPhone
      };
}

class userModel {
  String? id;
  // available for all users
  String? first_name = "";
  String last_name = "";
  String phone_number = "";
  String email = "";
  String user_type;
  String imageUrl = "";
  bool islandlord;
  String user_name;
  String access_token;
  String password = "";
  String refresh_token;
  bool active = false;
  String role = "";
  String date_created = "";
  bool fetchedparams = false;
  String updated_on = "";
  String user_status = "";
  // wsp only
  int wspId = 0;
  String companyname = "";
  String physicalAddress = "";
  int isVerified = 0;

  // Fp only
  int loginStatus = 0;

  //Driver only
  int fpId = 0;
  int DriverId = 0;
  String truckLicencePlate = "";
  String truckCapacity = "";
  String truckCost = "";

  bool hasWater = false;

  userModel({
    this.id = "",
    this.islandlord = false,
    this.first_name = "",
    this.email = "",
    this.fetchedparams = false,
    this.last_name = "",
    this.user_type = "",
    this.user_status = "",
    this.role = "",
    this.phone_number = "",
    this.refresh_token = "",
    this.user_name = "",
    this.updated_on = "",
    this.date_created = "",
    this.active = false,
    this.access_token = "",
    // wsp only
    this.companyname = "",
    this.imageUrl = "",
    this.physicalAddress = "",
    this.loginStatus = 0,

    //Driver only
    this.DriverId = 0,
    this.fpId = 0,
    this.truckLicencePlate = "",
    this.truckCapacity = "",
    this.truckCost = "",
    this.hasWater = false,
    
  });

  factory userModel.fromMap(json) {
    printLog("\n\nDEcipher user from ${json}");

    print(" -----${current_role == "WSP"} --");
    return userModel(
      email: json["email"] ?? "".toString(),
      first_name: json["firstName"] ?? "".toString(),
      last_name: json["lastName"] ?? "".toString(),
      phone_number: json["phoneNo"] ?? "".toString(),
      user_type: json["user_type"] ?? "".toString(),
      imageUrl: (json["imageUrl"] ?? "").toString().trim(),
      user_status: json["user_status"] ?? "".toString(),
      user_name: json["user_name"] ?? "".toString(),
      active:
          true, // (json["active"] ?? "").toString().toLowerCase() == "true",

      islandlord: json["user_type"] == "LANDLORD",
    access_token: (json["token"] ?? json["accessToken"] ?? "").toString(),
      role: json["role"] ?? "".toString(),
      id: current_role == "WSP"
          ? (json["wspId"] ?? "").toString()
          : (json["id"] ?? "").toString(),
      refresh_token: (json["refresh_token"] ?? "").toString().trim(),
      date_created: (json["date_created"] ?? "").toString().trim(),
      updated_on: (json["updated_on"] ?? "").toString().trim(),
      // wsp only
      companyname: (json["companyName"] ?? "").toString().trim(),
      physicalAddress: (json["physicalAddress"] ?? "").toString().trim(),

      //Driver only
      DriverId: (json["driverId"] ?? 0).toInt(),
      fpId: (json["fpId"] ?? 0).toInt(),
      truckLicencePlate: (json["truckLicencePlate"] ?? "").toString().trim(),
      truckCapacity: (json["truckCapacity"] ?? "").toString().trim(),
      truckCost: (json["truckCost"] ?? "").toString().trim(),
      hasWater: (json["hasWater"] ?? false),
    );
  }

  // Map<String, dynamic> toMap() => {
  //       "userdetails": {
  //         "username": email,
  //         "name": first_name,
  //         "phone": mobile_number,
  //       },
  //       "token": access_token,
  //       "meter": defaultmeter!.name,
  //       "mobile_number": mobile_number,
  //     };

  // static userModel fromJson(String str) {
  //   final jsonData = json.decode(str);
  //   return userModel.fromMap(jsonData);
  // }

  // String toJson(userModel data) {
  //   final dyn = data.toJsonMap();

  //   return json.encode(dyn);
  // }
// select cast(1 as bit) as rsp,@user_id as user_id, @user_type as user_type,@fname as first_name,@lname as last_name,@user_names as user_names;
  Map<String, dynamic> toJsonMap() => {
        "user_id": id,
        "user_type": user_type,
        "first_name": first_name,
        "last_name": last_name,
        "email": email,
        "user_names": user_name,
        "phone_number": phone_number,
      };
}
