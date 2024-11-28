// import 'package:encrypt/encrypt.dart';

import 'dart:convert';

import 'package:application/Models/Tarrifs.dart';
import 'package:application/utils/utils.dart';
import 'package:application/views/state/appbloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'comms_repo.dart';

const FCM_SERVER_KEY =
    'AAAAf4ESZe4:APA91bHymyWcal3_4bEP_Kp_znQPrHqwnmo3lQa1FSmwfNqfs5lhKhrRj9UEGFYaaxjiXs822YLV-fRUGQmZ3Rlmc7fktfwLSbpvEDl6iQtnSZNharxw2EjYMVV3lrLxGrNlXqo914x8';
const googleApiKey = "AIzaSyCoGPmVqQGHigzn_8WPHdy6M0wgbLlLZ-E";
const keyString = '0Dgkn6z1FH9qnVarospPi2F6iPlNzRIc';
// final aesEcb = AESECB();
final base_url = "http://185.141.63.56:8080/api/v2/"; // Qiu
final chatwesbsockURL = "http://185.141.63.56:8080";
final image_url = "https://api.cloudinary.com/v1_1/dt4yfuuuw/image/upload";

CommsRepository comms_repo = new CommsRepository();
// ImageRepository image_repo = new ImageRepository();

enum SnackBarType { success, error, info, warning }

final formkey = GlobalKey<FormState>();

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    String? actionLabel,
    Function()? onActionPressed,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 4),
  }) {
    // Dismiss any existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    final snackBar = SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      duration: duration,
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getBackgroundColor(type),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _getIcon(type),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTitle(type),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (actionLabel != null)
              TextButton(
                onPressed: onActionPressed,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text(actionLabel),
              ),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.02,
        left: 16,
        right: 16,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Color _getBackgroundColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return const Color(0xFF4CAF50);
      case SnackBarType.error:
        return const Color(0xFFE53935);
      case SnackBarType.warning:
        return const Color(0xFFFFA726);
      case SnackBarType.info:
        return const Color(0xFF2196F3);
    }
  }

  static Widget _getIcon(SnackBarType type) {
    IconData iconData;
    switch (type) {
      case SnackBarType.success:
        iconData = Icons.check_circle_outline;
        break;
      case SnackBarType.error:
        iconData = Icons.error_outline;
        break;
      case SnackBarType.warning:
        iconData = Icons.warning_amber;
        break;
      case SnackBarType.info:
        iconData = Icons.info_outline;
        break;
    }

    return Icon(
      iconData,
      color: Colors.white,
      size: 28,
    );
  }

  static String _getTitle(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return 'Success';
      case SnackBarType.error:
        return 'Error';
      case SnackBarType.warning:
        return 'Warning';
      case SnackBarType.info:
        return 'Information';
    }
  }
}

// Method to build text fields with consistent styling

Widget _buildTextField(String label, IconData icon,
    TextEditingController controller, String? Function(String?)? validator) {
  return TextFormField(
    validator: validator,
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Color(0xFF7E57C2)),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    style: GoogleFonts.poppins(fontSize: 16),
  );
}

// Method to open the edit modal and add model   for the wsp method , it's dynamic for all use
Future<void> showWSPModals(
    {required BuildContext context,
    TarrifsModel? model,
    required TextEditingController capcityController,
    required TextEditingController priceController,
    required bool isCreate}) {
  if (!isCreate) {
    capcityController.text = model!.truckCapacity;
    priceController.text = model.capacityPrice;
  }
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Form(
          key: formkey,
          child: FractionallySizedBox(
            heightFactor: 0.75,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 16,
                left: 16,
                right: 16,
              ),
              child: Column(
                children: [
                  Text(
                    "${isCreate ? "Create" : "Edit"} Tariff",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildTextField(
                    "Capacity (liters)",
                    Icons.water_drop_outlined,
                    capcityController,
                    (p0) {
                      if (p0!.isEmpty) {
                        return "Capacity is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  _buildTextField(
                    "Price",
                    Icons.attach_money,
                    priceController,
                    (p0) {
                      if (p0!.isEmpty) {
                        return "Price is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Closes the modal
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(color: Colors.black54),
                        ),
                      ),
                      context.watch<Appbloc>().isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                if (formkey.currentState?.validate() ?? false) {
                                  final String endpoint =
                                      "${base_url}wsp/${isCreate ? "tariff" : "tariff/:${model!.Id}"}";

                                  print("this is the wspId ${current_user.id}");

                                  final jsonstring = isCreate
                                      ? jsonEncode({
                                          "truckCapacity":
                                              int.parse(capcityController.text),
                                          "price":
                                              double.parse(priceController.text)
                                        })
                                      : jsonEncode({
                                          "id": model!.Id,
                                          "truckCapacity":
                                              int.parse(capcityController.text),
                                          "capacityPrice":
                                              double.parse(priceController.text)
                                        });

                                  print(
                                      "--------------$jsonstring---------------");
                                  print("---------endpoint is $endpoint");

                                  final function = await isCreate
                                      ? comms_repo.QueryAPIpost(
                                          endpoint, jsonstring, context)
                                      : comms_repo.QueryAPIPatch(
                                          endpoint, jsonstring, context);

                                  await function.then((value) {
                                    print(value);
                                    if (value["success"]) {
                                      CustomSnackBar.show(
                                        context: context,
                                        message:
                                            'Tarrif  ${isCreate ? "Created" : "Updated"}',
                                        type: SnackBarType.success,
                                      );

                                      Navigator.of(context).pop();
                                    } else {
                                      CustomSnackBar.show(
                                          context: context,
                                          message:
                                              "${isCreate ? "Create" : "Update"} error ${value["message"]}",
                                          type: SnackBarType.error);
                                      Navigator.of(context).pop();
                                    }
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF7E57C2),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: context.watch<Appbloc>().isLoading
                                  ? CircularProgressIndicator()
                                  : Text(
                                      isCreate ? "Add" : "Update",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white),
                                    ),
                            ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      });
}
