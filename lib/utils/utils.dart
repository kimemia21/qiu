// library utils;

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
export 'local_storage.dart';
export 'request.dart';
export 'screen_device.dart';
export 'authentication.dart';
import 'package:intl/intl.dart';
import '../comms/credentials.dart';
import '../Models/user.dart';

enum PaymentOption { mpesa, cash, card }

void printLog(String s) {
  if (kReleaseMode) return;
  final RegExp pattern = RegExp('.{1,500}'); // 800 is the size of each chunk
  pattern.allMatches(s).forEach((RegExpMatch match) => print(match.group(0)));
}

// Dateformat  tomorrow
final DateFormat dateformartzerotime = DateFormat('yyyy-MM-dd 00:00:00');
final DateFormat dateformartnotime = DateFormat('yyyy-MM-dd');
final DateFormat dateformartwithtime = DateFormat('yyyy-MM-dd kk:mm:ss');
final DateFormat dateformattimeonly = DateFormat('kk:mm:ss ms ');
final DateFormat dateformartend = DateFormat('yyyy-MM-dd 23:59:59');

// userModel current_user = new userModel(active: false);

const String STORAGE_USER_PROFILE_KEY = 'user_profile';
const String STORAGE_DEVICE_ALREADY_OPEN_KEY = 'device_already_open';

///
const String REGISTRATION_ID = 'reegistration_id';

String rawPhone = "";
String app_gate = "Earthview Smart Utilty";
String rawemail = "";

IndexUserModel currentIndexUser = IndexUserModel(
    active: false, userEmail: "", userName: "", userPass: "", userPhone: "");

userModel current_user = userModel(
  active: false,
  islandlord: false,
  first_name: "",
  last_name: "",
  access_token: "",
  user_name: "",
  user_type: "TENANT",
  id: "",
  phone_number: "",
  email: "",
  dob: "2021-01-01",
);

String firebaseToken =
    "eP9J4TYoQaKEj2wY07N_c8:APA91bH1yl_Qsx6zU4ZVxzpEfiLNHZ8xzCrP1y7hQ4JYtD1G0VWztxw8NxO94NxM5yNrSZx_G0rYd3F7CQUJ6xiAhNuFgO4kXaF-GZ";

bool validmpesa(String mpesaNo) {
  if (mpesaNo.isEmpty) return false;
  final regExp = RegExp(
      r'/^(\+){0,1}(254){0,1}(70|71|72|79)(\d{7})|(254){0,1}(7|1)(\d{8})');
  return regExp.hasMatch(mpesaNo);
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern.toString());
  return (!regex.hasMatch(value)) ? false : true;
}

String formatKenyanPhoneNumber(String phoneNumber) {
  // Ensure the phone number is not null or empty
  if (phoneNumber == null || phoneNumber.isEmpty) {
    return 'Invalid phone number';
  }

  // Remove any leading whitespace
  phoneNumber = phoneNumber.trim();

  // Check if the phone number starts with '0'
  if (phoneNumber.startsWith('0')) {
    // Remove the leading '0'
    phoneNumber = phoneNumber.substring(1);
  }

  if (phoneNumber.startsWith('+254')) {
    // Remove the leading '0'
    return phoneNumber;
  }
  // Define the country code for Kenya
  const String countryCode = '+254';

  // Concatenate the country code with the phone number
  String formattedNumber = countryCode + phoneNumber;

  // Ensure the formatted number has the correct length (including country code)
  if (formattedNumber.length != 13) {
    return 'Invalid phone number length';
  }

  return formattedNumber;
}

Future<bool> FetchParams() async {
  // get suer info

  if (current_user.islandlord) {
  } else {
    printLog("Fetch tenant default meter/meters ");

    // await comms_repo.getTenantMeters().then((value) {
    //   print("Got fetch params meters rsp $value");
    //   printLog("Found ${(value ?? []).length} meters ");

    //   if (value.length > 0) {
    //     current_user.fetchedparams = true;
    //   }
    // });
  }

  return Future.value(true);
}

TextStyle textstyle(double fontsize,
    {Color col = Colors.black87, FontWeight fontweight = FontWeight.normal}) {
  return TextStyle(
      color: col, // Color.fromRGBO(109, 109, 109, 1),
      fontFamily: 'Futura PT',
      fontSize: fontsize,
      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
      fontWeight: fontweight,
      height: 1);
}
