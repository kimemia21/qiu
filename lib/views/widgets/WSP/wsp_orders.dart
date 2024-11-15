import '../../../Models/Wsp_Orders.dart';
import '../../../comms/Req.dart';
import 'package:flutter/material.dart';

class WspOrdersScreen extends StatefulWidget {
  const WspOrdersScreen({Key? key}) : super(key: key);

  @override
  State<WspOrdersScreen> createState() => _WspOrdersScreenState();
}

class _WspOrdersScreenState extends State<WspOrdersScreen> {
  late Future<List<WspOrders>> _ordersData;
  final _gradientColors = const [Color(0xFF7E64D4), Color(0xFF9DD6F8)];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  void _fetchOrders() {
    setState(() {
      _ordersData = AppRequest.fetchWSP_Orders().catchError((error) {
        throw Exception('Failed to load orders: $error');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _gradientColors,
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<List<WspOrders>>(
            future: _ordersData,
            builder: _buildOrdersList,
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Water Orders',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchOrders,
          ),
        ],
      );

  Widget _buildOrdersList(
    BuildContext context,
    AsyncSnapshot<List<WspOrders>> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (snapshot.hasError) {
      return _ErrorView(error: snapshot.error.toString());
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const _EmptyView();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) => _OrderCard(order: snapshot.data![index]),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final WspOrders order;

  const _OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 1),
          _buildDetails(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.wspCompanyName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Order ID: ${order.orderId}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _StatusBadge(status: order.status),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _DetailRow(
            first: _DetailItem(
              icon: Icons.water_drop,
              label: 'Capacity',
              value: '${order.capacity} L',
            ),
            second: _DetailItem(
              icon: Icons.attach_money,
              label: 'Amount',
              value: 'KSH ${order.orderAmount}',
            ),
          ),
          const SizedBox(height: 16),
          _DetailRow(
            first: _DetailItem(
              icon: Icons.source,
              label: 'Water Source',
              value: order.wpWaterSrc,
            ),
            second: _DetailItem(
              icon: Icons.payment,
              label: 'Payment',
              value: order.paymentStatus,
              isPaymentStatus: true,
            ),
          ),
          const SizedBox(height: 16),
          _DetailItem(
            icon: Icons.location_on,
            label: 'Address',
            value: order.wspAddress,
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusConfig = _getStatusConfig(status.toUpperCase());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusConfig.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusConfig.icon, size: 16, color: statusConfig.color),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: statusConfig.color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  ({Color color, IconData icon}) _getStatusConfig(String status) {
    switch (status) {
      case 'PENDING':
        return (color: Colors.orange, icon: Icons.pending);
      case 'COMPLETED':
        return (color: Colors.green, icon: Icons.check_circle);
      case 'CANCELLED':
        return (color: Colors.red, icon: Icons.cancel);
      default:
        return (color: Colors.grey, icon: Icons.info);
    }
  }
}

class _DetailRow extends StatelessWidget {
  final Widget first;
  final Widget second;

  const _DetailRow({Key? key, required this.first, required this.second})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: first),
        const SizedBox(width: 16),
        Expanded(child: second),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isPaymentStatus;

  const _DetailItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    this.isPaymentStatus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final valueColor = isPaymentStatus
        ? value.toLowerCase() == 'paid'
            ? Colors.green
            : Colors.orange
        : Colors.black87;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
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

class _ErrorView extends StatelessWidget {
  final String error;

  const _ErrorView({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Error Loading Orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox, color: Colors.grey, size: 48),
            SizedBox(height: 16),
            Text(
              'No Orders Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}