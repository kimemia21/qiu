import 'package:application/comms/credentials.dart';
import 'package:application/views/widgets/WSP/homepage/wspglobals.dart';

import '../../../Models/OrderModel.dart';
import '../globals.dart';
import '../../../comms/Req.dart';
import 'package:flutter/material.dart';

class AppOrders extends StatefulWidget {
  const AppOrders({super.key});

  @override
  State<AppOrders> createState() => _AppOrdersState();
}

class _AppOrdersState extends State<AppOrders> {
  late Future<List<OrderModel>> _ordersFuture;
  @override
  void initState() {
    super.initState();
    _ordersFuture = fetchorders();
  }

  Future<List<OrderModel>> fetchorders() async {
    return await AppRequest.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient container
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF9FA8DA),
                  Color(0xFF7E57C2),
                ],
              ),
            ),
          ),

          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            ),
          ),

          Positioned(
            top: 120,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FutureBuilder<List<OrderModel>>(
                  future: _ordersFuture,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<OrderModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: ErrorState(
                              context: context,
                              error: snapshot.error.toString(),
                              function: () {})); // Show error if any
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: EmptyState(
                              type: "Orders")); // Show message if no data
                    }

                    return ListView.builder(
                      physics:
                          NeverScrollableScrollPhysics(), // Prevent scrolling within the ListView itself
                      shrinkWrap:
                          true, // Ensure the ListView only takes up as much space as needed
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final order = snapshot.data![index];
                        return OrderStatusWidget(model: order); // Custom widget
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WspOrders extends StatefulWidget {
  final List<OrderModel> orders;
  const WspOrders({super.key, required this.orders});

  @override
  State<WspOrders> createState() => _WspOrdersState();
}

// virginia
class _WspOrdersState extends State<WspOrders> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SizedBox(
          height: MediaQuery.of(context).size.height, // Explicit height
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.orders.length,
            itemBuilder: (BuildContext context, int index) {
              final order = widget.orders[index];
              return OrderStatusWidget(model: order); // Custom widget
            },
          ),
        ),
      ),
    );
  }
}

class OrderStatusWidget extends StatelessWidget {
  final OrderModel model;

  const OrderStatusWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return _buildOrderCard(context);
  }

  Widget _buildOrderCard( context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF0E6FF),
            Color(0xFFE6D9FF),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Order NO. ${model.orderId}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildStatusIndicators(),
          const SizedBox(height: 25),
          _buildOrderDetails(),
          const SizedBox(height: 20),
          _fulfilledButton(orderId: model.orderId, context:context ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatusDot('PENDING', model.orderStatus == "PENDING"),
        _buildStatusDot('CONFIRMED', model.orderStatus == "CONFIRMED"),
        _buildStatusDot('CANCELLED', model.orderStatus == "CANCELLED"),
        _buildStatusDot('FULFILLED', model.orderStatus == "FULFILLED"),
      ],
    );
  }

  Widget _buildStatusDot(String label, bool isActive) {
    Color dotColor;
    Color textColor;

    if (isActive) {
      switch (label) {
        case 'PENDING':
          dotColor = Colors.orange;
          textColor = Colors.orange;
          break;
        case 'CONFIRMED':
          dotColor = Colors.green;
          textColor = Colors.green;
          break;
        case 'CANCELLED':
          dotColor = Colors.red;
          textColor = Colors.red;
          break;
        case 'FULFILLED':
          dotColor = Colors.blue;
          textColor = Colors.blue;
          break;
        default:
          dotColor = Colors.grey;
          textColor = Colors.grey;
      }
    } else {
      dotColor = Colors.grey[300]!;
      textColor = Colors.grey;
    }

    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetails() {
    return Column(
      children: [
        Text('Customer: ${model.driverName}'),
        const SizedBox(height: 8),
        Text('Order No: ${model.orderId}'),
        const SizedBox(height: 8),
        Text('Status: ${model.orderStatus}'),
        const SizedBox(height: 8),
        Text('Estimated Delivery Time: ${model.orderDate}'),
        const SizedBox(height: 8),
        Text('Estimated Cost: ${model.orderAmount.toString} ksh'),
      ],
    );
  }

  Widget _fulfilledButton(
      {required String orderId, required BuildContext context}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final jsonString = {
            "order_id": orderId,
          };
          comms_repo.QueryAPIPatch("wsp/orders/fulfill", jsonString, context)
              .then((value) {
            if (value["success"]) {
              print("fulfilled");
            }
            print(value);
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7B89F4),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Mark As Fulfilled '),
      ),
    );
  }
}
