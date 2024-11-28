import 'package:application/Models/OrderModel.dart';
import 'package:application/comms/Req.dart';
import 'package:application/views/widgets/WSP/homepage/wspglobals.dart';
import 'package:flutter/material.dart';

class OrdersToWsp extends StatefulWidget {
  const OrdersToWsp({super.key});

  @override
  State<OrdersToWsp> createState() => _OrdersToWspState();
}

class _OrdersToWspState extends State<OrdersToWsp> {
  late Future<List<OrderModel>> orders;

  @override
  void initState() {
    super.initState();
    orders = AppRequest.fetchOrders(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: FutureBuilder<List<OrderModel>>(
            future: orders,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ErrorState(
                          context: context,
                          error: snapshot.error.toString(),
                          function: () {})),
                );
              } else if (snapshot.data!.isEmpty) {
                return Center(
                  child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child:EmptyState(type: "WSP Orders")),
                );
              }
              else{
                final data = snapshot.data!;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return tile(order: data[index]);
                  },
                );
                 
              }
            }),
      ),
    );
  }

  Widget tile({required OrderModel order}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.orderId,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.orderStatus),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.orderStatus,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Order Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailColumn(
                  title: 'Capacity',
                  value: order.orderCapacity.toString(),
                  icon: Icons.water_drop_outlined,
                ),
                _buildDetailColumn(
                  title: 'Order Amount',
                  value: 'KES ${order.orderAmount}',
                  icon: Icons.monetization_on_outlined,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Company and Payment Details
            _buildInfoRow(
              title: 'Company',
              value: order.wspCompanyName!,
              icon: Icons.business_outlined,
            ),
            const Divider(height: 16),
            _buildInfoRow(
              title: 'Water Source',
              value: order.wpWaterSrc!,
              icon: Icons.water_outlined,
            ),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoRow(
                  title: 'Address',
                  value: order.wspAdrress!,
                  icon: Icons.location_on_outlined,
                  flex: 3,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPaymentStatusColor(order.paymentStatus),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.paymentStatus.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getPaymentStatusColor(String paymentStatus) {
    switch (paymentStatus.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'not paid':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Widget _buildDetailColumn({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String title,
    required String value,
    required IconData icon,
    int flex = 1,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: 20),
        const SizedBox(width: 8),
        Expanded(
          flex: flex,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
