import 'package:application/Models/Wsp_Orders.dart';
import 'package:application/comms/Req.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// Import your WspOrders model and API request class

class WspOrdersScreen extends StatefulWidget {
  @override
  _WspOrdersScreenState createState() => _WspOrdersScreenState();
}

class _WspOrdersScreenState extends State<WspOrdersScreen> {
  Future<List<WspOrders>>? _ordersData;

  @override
  void initState() {
    super.initState();
    _ordersData = AppRequest.fetchWSP_Orders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF7E64D4),
        title: Text(
          'Water Orders',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _ordersData = AppRequest.fetchWSP_Orders();
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7E64D4),
              Color(0xFF9DD6F8),
            ],
          ),
        ),
        child: FutureBuilder<List<WspOrders>>(
          future: _ordersData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else if (snapshot.hasError) {
              print('Error loading orders: ${snapshot.error}');
              return Center(
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 16),
                      Text(
                        'Error loading orders ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final order = snapshot.data![index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          // Order Header
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF7E64D4).withOpacity(0.1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.wspCompanyName,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF7E64D4),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Order ID: ${order.orderId}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildStatusBadge(order.status),
                              ],
                            ),
                          ),
                          
                          // Order Details
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // Capacity and Amount Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDetailItem(
                                        Icons.water_drop,
                                        'Capacity',
                                        '${order.capacity} L',
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildDetailItem(
                                        Icons.attach_money,
                                        'Amount',
                                        'KSH ${order.orderAmount}',
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                
                                // Source and Payment Status Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDetailItem(
                                        Icons.source,
                                        'Water Source',
                                        order.wpWaterSrc,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildDetailItem(
                                        Icons.payment,
                                        'Payment',
                                        order.paymentStatus,
                                        isPaymentStatus: true,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                // Address
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: _buildDetailItem(
                                    Icons.location_on,
                                    'Address',
                                    order.wspAddress,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inbox, color: Colors.grey, size: 48),
                      SizedBox(height: 16),
                      Text(
                        'No orders found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status.toUpperCase()) {
      case 'PENDING':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade900;
        icon = Icons.pending;
        break;
      case 'COMPLETED':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade900;
        icon = Icons.check_circle;
        break;
      case 'CANCELLED':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade900;
        icon = Icons.cancel;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade900;
        icon = Icons.info;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value, {bool isPaymentStatus = false}) {
    Color valueColor = Colors.black87;
    if (isPaymentStatus) {
      valueColor = value.toLowerCase() == 'paid' 
          ? Colors.green 
          : Colors.orange;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}