import 'package:application/main.dart';
import 'package:application/views/state/appbloc.dart';
import 'package:application/views/widgets/homepage/HomeScreen.dart';
import 'package:flutter/material.dart';

class Authrequest {
  static Future createUser(
      {required BuildContext context,
      required Map<String, dynamic> body}) async {
    print("Called");

    // api call

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
