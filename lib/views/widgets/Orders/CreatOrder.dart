import 'package:application/views/widgets/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../Maps/MapScreen.dart';
import '../../state/appbloc.dart';

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
      quantityController.text = quantity.toString();
    });
    context.read<Appbloc>().changeLiters(quantity * 1000);
  }

  void decreaseQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
        quantityController.text = quantity.toString();
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
    quantity = Provider.of<Appbloc>(context, listen: false).quantityLiters != null
        ? (Provider.of<Appbloc>(context, listen: false).quantityLiters! / 1000).toInt()
        : 0;
    quantityController.text = quantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    final formattedQuantity = NumberFormat('#,###').format(quantity * 1000);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:appGradient[0],
        title: Text('Create Order', style: GoogleFonts.poppins(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Gradient Background
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF9FA8DA),
                      Color(0xFF7E57C2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            Positioned.fill(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 100), // Space for the background
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Quantity Display
                              Center(
                                child: Text(
                                  '$formattedQuantity Litres',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),

                              // Quantity Control
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Quantity',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove_circle_outline, color: Colors.grey),
                                            onPressed: decreaseQuantity,
                                          ),
                                          SizedBox(
                                            width: 60,
                                            child: TextField(
                                              controller: quantityController,
                                              keyboardType: TextInputType.number,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 18),
                                              inputFormatters: [
                                                FilteringTextInputFormatter.digitsOnly,
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  quantity = int.tryParse(value) ?? 0;
                                                });
                                                context.read<Appbloc>().changeLiters(quantity * 1000);
                                              },
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.add_circle_outline, color: Colors.blue),
                                            onPressed: increaseQuantity,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),

                              // Delivery Options
                              Text(
                                'Delivery Options',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 10),
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    _buildDeliveryOption('Express Delivery', 'EXP'),
                                    Divider(),
                                    _buildDeliveryOption('Scheduled Delivery', 'SCH'),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),

                              // Confirm Button
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (quantity == 0 ||  selectedDeliveryOption=="Exp") {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Please fill in the values'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: MapScreen(),
                                      withNavBar: true,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: Text(
                                    'CONFIRM ORDER',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

  Widget _buildDeliveryOption(String title, String option) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: selectedDeliveryOption == option ? Colors.blue[700] : Colors.black87,
        ),
      ),
      trailing: Icon(
        selectedDeliveryOption == option ? Icons.check_circle : Icons.radio_button_off,
        color: selectedDeliveryOption == option ? Colors.blueAccent : Colors.grey,
      ),
      onTap: () => selectDeliveryOption(option),
    );
  }
}