import 'package:application/Models/DriverModel.dart';
import 'package:application/Models/OrderModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController myController;
  final String? hintText;
  final bool? isPassword;
  final String? Function(String?)? validator; // Add validator function

  const CustomTextfield({
    Key? key,
    required this.myController,
    this.hintText,
    this.isPassword,
    this.validator, // Accept validator as a parameter
  }) : super(key: key);

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool hidepass = false;

  @override
  void initState() {
    super.initState();
    hidepass = widget.isPassword ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        // Use TextFormField instead of TextField
        keyboardType: widget.isPassword!
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        enableSuggestions: widget.isPassword! ? false : true,
        autocorrect: widget.isPassword! ? false : true,
        obscureText: hidepass,
        controller: widget.myController,
        decoration: InputDecoration(
          suffixIcon: widget.isPassword!
              ? IconButton(
                  icon: Icon(Icons.remove_red_eye,
                      color: hidepass ? Colors.grey : Colors.green),
                  onPressed: () {
                    setState(() {
                      hidepass = !hidepass;
                    });
                  },
                )
              : null,
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffE8ECF4), width: 1),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffE8ECF4), width: 1),
              borderRadius: BorderRadius.circular(10)),
          fillColor: const Color(0xffE8ECF4),
          filled: true,
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: widget.validator, // Pass the validator to TextFormField
      ),
    );
  }
}

Widget buildWideButton(
    BuildContext context, String text, Color color, onpressed,
    {bool showarrow = true}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(
            color: Colors.white,
            width: 1.5,
          ),
        ),
      ),
      onPressed: onpressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: TextStyle(fontSize: 18)),
          if (showarrow) Icon(Icons.arrow_forward),
        ],
      ),
    ),
  );
}

Widget CustomButton(BuildContext context, String text, pressed) {
  return Container(
    width: 220,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
              color: Colors.white,
              width: 1.5,
            ),
          ),
        ),
        onPressed: pressed,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                text,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Positioned(
              right: 0,
              child: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    ),
  );
}

class CustomMenuItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool showDivider;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;
  final bool dense;

  const CustomMenuItem({
    Key? key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.showDivider = true,
    this.iconColor,
    this.textColor,
    this.iconSize = 20,
    this.dense = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 65,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onPressed,
            child: Container(
              constraints: BoxConstraints(
                minHeight: dense ? 48.0 : 56.0,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: dense ? 8.0 : 12.0,
              ),
              child: Row(
                children: [
                  // Leading Icon
                  Icon(
                    icon,
                    size: iconSize,
                    color: iconColor ??
                        Theme.of(context).primaryColor.withOpacity(0.7),
                  ),
                  SizedBox(width: 16.0),

                  // Title
                  Expanded(
                    child: Text(
                      text,
                      style: GoogleFonts.poppins(
                        fontSize: dense ? 14.0 : 16.0,
                        color: textColor ?? Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  // Trailing Icon
                  Icon(
                    Icons.chevron_right,
                    size: dense ? 20.0 : 24.0,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),

          // Optional Divider
          if (showDivider)
            Padding(
              padding: const EdgeInsets.only(left: 56.0),
              child: Divider(
                height: 1,
                thickness: 0.5,
                color: Colors.black12,
              ),
            ),
        ],
      ),
    );
  }
}

// Usage Example:
class ExampleUsage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomMenuItem(
          text: 'Home',
          icon: Icons.home_outlined,
          onPressed: () {
            // Handle navigation
          },
          iconColor: Theme.of(context).primaryColor,
        ),
        CustomMenuItem(
          text: 'Settings',
          icon: Icons.settings_outlined,
          onPressed: () {
            // Handle navigation
          },
          dense: false, // Larger touch target
          showDivider: false, // Last item
        ),
      ],
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
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFFFF9800) : Colors.grey[300],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? Colors.black : Colors.grey,
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

class DriverCard extends StatelessWidget {
  final Drivermodel model;

  const DriverCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const Divider(height: 1),
                _buildBody(),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: _buildStatusIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              size: 32,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model.firstName} ${model.lastName}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                _buildInfoChip(
                  icon: Icons.local_shipping,
                  label: model.assignedTruck,
                  backgroundColor: Colors.purple.shade50,
                  textColor: Colors.purple.shade700,
                  iconColor: Colors.purple.shade700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildDetailRow(
            icon: Icons.phone,
            title: 'Contact Number',
            value: model.phone,
            iconColor: Colors.blue.shade700,
            backgroundColor: Colors.blue.shade50,
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            icon: Icons.access_time,
            title: 'Availability',
            value: model.avaiable == 1 ? "Available" : "Unavailable",
            iconColor: model.avaiable == 1 ? Colors.green.shade700 : Colors.red.shade700,
            backgroundColor: model.avaiable == 1 ? Colors.green.shade50 : Colors.red.shade50,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    final isOnline = model.isOnline == 1;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOnline ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOnline ? Colors.green.shade200 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOnline ? Colors.green : Colors.grey,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              color: isOnline ? Colors.green.shade700 : Colors.grey.shade700,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: iconColor,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey.shade900,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



List<Map<String, dynamic>> dummyData = [
  {
    "status": "FULFILLED", // Changed from "delivered"
    "name": "Order A",
    "id": 1,
    "deliveryDate": DateTime.parse("2024-10-01"),
    "price": 100.50
  },
  {
    "status": "PENDING", // Changed from "pending"
    "name": "Order B",
    "id": 2,
    "deliveryDate": DateTime.parse("2024-10-15"),
    "price": 200.75
  },
  {
    "status": "FULFILLED", // Changed from "shipped"
    "name": "Order C",
    "id": 3,
    "deliveryDate": DateTime.parse("2024-11-01"),
    "price": 150.00
  },
  {
    "status": "CANCELLED", // Changed from "canceled"
    "name": "Order D",
    "id": 4,
    "deliveryDate": DateTime.parse("2024-09-25"),
    "price": 80.00
  },
  {
    "status": "CONFIRMED", // Changed from "processing"
    "name": "Order E",
    "id": 5,
    "deliveryDate": DateTime.parse("2024-12-05"),
    "price": 300.00
  }
];

List driversDummy = [
  {
    "truck": "Freightliner Cascadia",
    "phone": "555-0123",
    "avaiable": true,
    "status": "Active",
    "name": "john Doe",
  },
  {
    "truck": "Volvo VNL",
    "phone": "555-0456",
    "avaiable": false,
    "status": "On Duty",
    "name": "john Doe",
  },
  {
    "truck": "Kenworth T680",
    "phone": "555-0789",
    "avaiable": true,
    "status": "Available",
    "name": "john Doe",
  },
  {
    "truck": "Peterbilt 579",
    "phone": "555-1011",
    "avaiable": true,
    "status": "Active",
    "name": "john Doe",
  },
  {
    "truck": "Mack Anthem",
    "phone": "555-1213",
    "avaiable": false,
    "status": "Under Maintenance",
    "name": "john Doe",
  }
];

List<Map<String, dynamic>> dummyTrucksData = [
  {
    "id": "1",
    "capacity": 10.5,
    "quality": "High",
    "reg": "ABC-1234",
  },
  {
    "id": "2",
    "capacity": 15.0,
    "quality": "Medium",
    "reg": "XYZ-5678",
  },
  {
    "id": "3",
    "capacity": 8.0,
    "quality": "Low",
    "reg": "LMN-9012",
  },
  {
    "id": "4",
    "capacity": 12.3,
    "quality": "High",
    "reg": "OPQ-3456",
  },
  {
    "id": "5",
    "capacity": 20.0,
    "quality": "Medium",
    "reg": "RST-7890",
  },
  {
    "id": "6",
    "capacity": 5.5,
    "quality": "Low",
    "reg": "UVW-1357",
  },
];

List<Map<String, dynamic>> locationData = [
  {
    "place": "Home",
    "lat": 40.748817,
    "lng": -73.985428,
    "description": "New York City Apartment",
  },
  {
    "place": "Office",
    "lat": 34.052235,
    "lng": -118.243683,
    "description": "Los Angeles Downtown Office",
  },
];
