import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:status_alert/status_alert.dart';
import 'colors.dart';

//

showalert(success, context, title, subtitle, [int secs = 2]) {
  success
      ? StatusAlert.show(context,
          duration: Duration(seconds: secs),
          title: title,
          subtitle: subtitle,
          titleOptions: StatusAlertTextConfiguration(
              style: const TextStyle(
                  fontFamily: 'SFNS', color: Colors.black, fontSize: 30)),
          subtitleOptions: StatusAlertTextConfiguration(
              style: const TextStyle(fontFamily: 'SFNS', color: Colors.black)),
          configuration:
              const IconConfiguration(icon: Icons.done, color: Colors.green),
          backgroundColor: Colors.green)
      : StatusAlert.show(
          context,
          duration: Duration(seconds: secs),
          subtitleOptions: StatusAlertTextConfiguration(
              style: const TextStyle(fontFamily: 'SFNS', color: Colors.black)),
          title: title,
          titleOptions: StatusAlertTextConfiguration(
              style: const TextStyle(
                  fontFamily: 'SFNS', color: Colors.black, fontSize: 30)),
          subtitle: subtitle,
          configuration:
              const IconConfiguration(icon: Icons.error, color: Colors.red),
        );
}

myButtons(ctx, txt, preicon, pressed,
        {double width = 255, Color bgcolor = Colors.blue}) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 45,
          width: width,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: bgcolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            // onPressed: () => Get.to(const CheckOutView()),
            onPressed: pressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  preicon,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  txt,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

processingWidget(String txt,
        [double fontsize = 30, Color fontcolor = AppColors.appblue]) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinKitPulse(color: fontcolor),
        Text(
          txt,
          style: TextStyle(
              color: fontcolor,
              fontSize: fontsize,
              fontWeight: FontWeight.w500),
        ),
        SpinKitPulse(
          color: fontcolor,
        ),
      ],
    );

inputField(TextEditingController? cnt, String hint,
    {ispassword = false, lines = 1, height = 40.0, width = 0}) {
  return Container(
    width: width == 0 ? 300 : width,
    child: Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: TextField(
          controller: cnt,
          obscureText: ispassword,
          style: const TextStyle(color: Colors.black, fontSize: 18),
          decoration: InputDecoration(
            labelText: hint,
            labelStyle: const TextStyle(color: Colors.black),
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          ),
        ),
      ),
    ),
  );
}

labelField(title, value) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        '$title',
        style: const TextStyle(fontSize: 18.0, color: Colors.black87),
      ),
      Text(
        '$value',
        style: const TextStyle(fontSize: 20.0, color: Colors.black87),
      ),
    ],
  );
}

phoneinputField(TextEditingController cnt, String hint,
    {double width_ratio = 0.6}) {
  return Container(
    width: MediaQuery.of(Get.context!).size.width * 0.8,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Colors.grey.shade300),
    //   border: Border.all(color: Colors.black87)),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset(
            "assets/images/kenya.png",
            height: 30,
          ),
        ),
        Text(
          "+254 ",
          style: TextStyle(
            color: const Color.fromRGBO(30, 30, 30, 1),
            fontSize: 20,
            fontFamily: "Inter",
            fontWeight: FontWeight.normal,
          ),
        ),
        Container(
          width: 2,
          height: 20,
          color: Colors.black87,
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          color: Colors.grey.shade300,
          width: MediaQuery.of(Get.context!).size.width * 0.5,
          height: 50,
          child: TextField(
            style: TextStyle(
                color: Colors.grey[800],
                fontSize: 18,
                fontFamily: "Inter",
                fontWeight: FontWeight.normal),
            controller: cnt,
            //   keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            keyboardType: Platform.isIOS
                ? const TextInputType.numberWithOptions(
                    signed: true, decimal: true)
                : TextInputType.number,
// This regex for only amount (price). you can create your own regex based on your requirement
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}'))
            ],

            //       keyboardType:
            // const TextInputType.numberWithOptions(signed: true, decimal: true),
            // textInputAction: TextInputAction.done,

            // inputFormatters: <TextInputFormatter>[
            //   FilteringTextInputFormatter.digitsOnly
            // ], // Only numbers can be entered

            decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintStyle: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 18,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.normal),
                hintText: hint,
                fillColor: Colors.grey.shade300),
          ),
        ),
      ],
    ),
  );
}
