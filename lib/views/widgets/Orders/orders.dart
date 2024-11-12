import 'package:application/Models/OrderModel.dart';
import 'package:application/views/widgets/globals.dart';
import 'package:application/comms/Req.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

// virginia
class _OrdersState extends State<Orders> {
  @override
  void initState() {
    super.initState();
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
                child: FutureBuilder<List<Ordermodel>>(
                  future: AppRequest.fetchOrders(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Ordermodel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              'Error: ${snapshot.error}')); // Show error if any
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text(
                              'No Orders Available')); // Show message if no data
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





class OrderStatusWidget extends StatelessWidget {
  final Ordermodel model;

  const OrderStatusWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return _buildOrderCard();
  }

  Widget _buildOrderCard() {
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
              'Order NO. ${model.id}',
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
          _buildArchiveButton(),
        ],
      ),
    );
  }

  Widget _buildStatusIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatusDot('PENDING', model.status == "PENDING"),
        _buildStatusDot('CONFIRMED', model.status == "CONFIRMED"),
        _buildStatusDot('CANCELLED', model.status == "CANCELLED"),
        _buildStatusDot('FULFILLED', model.status == "FULFILLED"),
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
        Text('Customer: ${model.name}'),
        const SizedBox(height: 8),
        Text('Order No: ${model.id}'),
        const SizedBox(height: 8),
        Text('Status: ${model.status}'),
        const SizedBox(height: 8),
        Text('Estimated Delivery Time: ${_formatDateTime(model.deliveryDate)}'),
        const SizedBox(height: 8),
        Text('Estimated Cost: ${model.price.toStringAsFixed(0)} ksh'),
      ],
    );
  }

  Widget _buildArchiveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7B89F4),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('ARCHIVE ORDER'),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final day = dateTime.day;
    final month = _getMonth(dateTime.month);
    final year = dateTime.year;

    return '$hour:$minute AM $day${_getDaySuffix(day)} $month $year';
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}