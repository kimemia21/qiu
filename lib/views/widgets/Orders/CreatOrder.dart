import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CreateOrderScreen extends StatefulWidget {
  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
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
    }
  }

  void selectDeliveryOption(String option) {
    setState(() {
      selectedDeliveryOption = option;
    });
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
                    colors: [  Color(0xFF9FA8DA),
                  Color(0xFF7E57C2),],
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
                  height: 500, // Adjust height to suit
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
                                selectedDeliveryOption == 'Express Delivery'
                                    ? Icons.check_circle
                                    : Icons.radio_button_off,
                                color:
                                    selectedDeliveryOption == 'Express Delivery'
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
                                selectedDeliveryOption == 'Scheduled Delivery'
                                    ? Icons.check_circle
                                    : Icons.radio_button_off,
                                color: selectedDeliveryOption ==
                                        'Scheduled Delivery'
                                    ? Colors.blueAccent
                                    : Colors.grey,
                              ),
                              onTap: () {
                                selectDeliveryOption('Scheduled Delivery');
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
                            // Confirm order action
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
                              color: Colors.white,
                              fontSize: 16),
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
