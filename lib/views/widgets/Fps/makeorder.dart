import 'package:application/Models/TrucksModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../../comms/credentials.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets.dart';
import '../../state/appbloc.dart';
import '../Maps/MapScreen.dart';

Future<dynamic> FPMakeOrder(BuildContext context) async {
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: Colors.white,
      context: context,
      isDismissible: true,
      showDragHandle: true,
      // enableDrag:,
      isScrollControlled: true,
      builder: (context) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const MakeOrder()));
}

class MakeOrder extends StatefulWidget {
  const MakeOrder({super.key});
  @override
  _MakeOrderState createState() => _MakeOrderState();
}

class _MakeOrderState extends State<MakeOrder> {
  final _formKey = GlobalKey<FormState>();

  bool saveorder = false;

  List<Trucksmodel> trucks = [];
  Trucksmodel? _selectedtruck;
  int quantity = 0;
  String selectedDeliveryOption = 'Express Delivery';
  TextEditingController quantityController = TextEditingController();
  void increaseQuantity() {
    setState(() {
      quantity++;

      int currentQuantity = int.parse(quantityController.text);
      if (currentQuantity > 0) {
        quantityController.text = (currentQuantity + 1).toString();
      }
    });
    context.read<Appbloc>().changeLiters(quantity * 1000);
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        int currentQuantity = int.parse(quantityController.text);
        if (currentQuantity > 0) {
          quantityController.text = (currentQuantity - 1).toString();
        }
      });

      context.read<Appbloc>().changeLiters(quantity * 1000);
    }
  }

  void selectDeliveryOption(String option) {
    setState(() {
      selectedDeliveryOption = option;
    });
  }

  @override
  void initState() {
    super.initState();
    if (Provider.of<Appbloc>(context, listen: false).quantityLiters == null) {
      quantity = 0;
      quantityController.text = 0.toString();
    } else {
      quantity =
          (Provider.of<Appbloc>(context, listen: false).quantityLiters! / 1000)
              .toInt();
      quantityController.text = quantity.toString();
    }
  }

  Future<void> _submitForm() async {
    if (_selectedtruck == null) {
      showalert(false, context, "Missing ", "Select The Truck");
      return;
    }

    if (_formKey.currentState!.validate()) {
      final truckData = {
        // 'firstName': _firstnamecontroller.text.trim(),
        // 'truckId': _selectedtruck!.id,
        // 'lastName': _lastnamecontroller.text.trim(),
        // 'phoneNo': _phonecontroller.text.replaceAll(" ", ""),
      };

      print('Truck Data: $truckData');

      await comms_repo.QueryAPIpost("fp/add-driver", truckData, context)
          .then((value) {
        printLog("Save driver  info $value");

        setState(() {
          saveorder = false;
        });

        if (value["success"] ?? false) {
          showalert(
              true, context, "Success", value["message"] ?? "Driver Saved");
        } else {
          showalert(false, context, "Failed",
              value["message"] ?? "Unable to Save Driver");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedQuantity = NumberFormat('#,###').format(quantity * 1000);

    return FractionallySizedBox(
        heightFactor: 0.7,
        // widthFactor: 0.9,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Make Order",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 500,
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$formattedQuantity Litres',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 20),
                            // Quantity section
                            Container(
                                padding: EdgeInsets.all(3),
                                margin: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadiusDirectional.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Quantity',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove),
                                            onPressed: decreaseQuantity,
                                            color: Colors.grey,
                                          ),
                                          Flexible(
                                            child: Container(
                                              constraints:
                                                  BoxConstraints(maxWidth: 80),
                                              child: TextField(
                                                controller: quantityController,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                                onChanged: (value) {
                                                  setState(() {
                                                    quantity =
                                                        int.tryParse(value) ??
                                                            1;
                                                  });
                                                  context
                                                      .read<Appbloc>()
                                                      .changeLiters(
                                                          quantity * 1000);
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 5),
                                                  border: OutlineInputBorder(),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.add),
                                            onPressed: increaseQuantity,
                                            color: Colors.blueAccent,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                            SizedBox(height: 30),
                            // Delivery options
                            Text(
                              'Delivery Options',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text('Express Delivery'),
                                    trailing: Icon(
                                      selectedDeliveryOption ==
                                              'Express Delivery'
                                          ? Icons.check_circle
                                          : Icons.radio_button_off,
                                      color: selectedDeliveryOption ==
                                              'Express Delivery'
                                          ? Colors.blueAccent
                                          : Colors.grey,
                                    ),
                                    onTap: () {
                                      selectDeliveryOption('Express Delivery');
                                    },
                                  ),
                                  Divider(),
                                  ListTile(
                                    title: Text('Scheduled Delivery'),
                                    trailing: Icon(
                                      selectedDeliveryOption ==
                                              'Scheduled Delivery'
                                          ? Icons.check_circle
                                          : Icons.radio_button_off,
                                      color: selectedDeliveryOption ==
                                              'Scheduled Delivery'
                                          ? Colors.blueAccent
                                          : Colors.grey,
                                    ),
                                    onTap: () {
                                      selectDeliveryOption(
                                          'Scheduled Delivery');
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            // Confirm button
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Confirm order action\\\\\\\\\\\\\
                                  PersistentNavBarNavigator.pushNewScreen(
                                      withNavBar: true,
                                      context,
                                      screen: MapScreen());
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'CONFIRM ORDER',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        )));
  }
}
