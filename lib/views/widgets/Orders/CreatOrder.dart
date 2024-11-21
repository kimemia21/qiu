import '../../../main.dart';
import '../../state/appbloc.dart';
import '../Maps/MapScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class CreateOrderScreen extends StatefulWidget {
  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  int quantity = 0;
  String selectedDeliveryOption = 'EXP';
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
      // context.read<Appbloc>().changeDeliveryDetails(deliveryType: option);
      
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

  @override
  Widget build(BuildContext context) {
    final formattedQuantity = NumberFormat('#,###').format(quantity * 1000);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background decoration at the top
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF9FA8DA),
                      Color(0xFF7E57C2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(40)),
                ),
              ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Quantity',
                                style: TextStyle(fontSize: 18),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              quantity =
                                                  int.tryParse(value) ?? 1;
                                            });
                                            context
                                                .read<Appbloc>()
                                                .changeLiters(quantity * 1000);
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
                                selectedDeliveryOption == 'EXP'
                                    ? Icons.check_circle
                                    : Icons.radio_button_off,
                                color:
                                    selectedDeliveryOption == 'EXP'
                                        ? Colors.blueAccent
                                        : Colors.grey,
                              ),
                              onTap: () {
                                selectDeliveryOption('EXP');
                              },
                            ),
                            Divider(),
                            ListTile(
                              title: Text('Scheduled Delivery'),
                              trailing: Icon(
                                selectedDeliveryOption == 'SCH'
                                    ? Icons.check_circle
                                    : Icons.radio_button_off,
                                color: selectedDeliveryOption ==
                                        'SCH'
                                    ? Colors.blueAccent
                                    : Colors.grey,
                              ),
                              onTap: () {
                                selectDeliveryOption('SCH');
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
                                withNavBar: true, context, screen: MapScreen());
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
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
