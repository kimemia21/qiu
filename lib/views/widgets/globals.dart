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
  final String customerName;
  final String orderNo;
  final String status;
  final DateTime estimatedDelivery;
  final double estimatedCost;
  final Ordermodel model;

  const OrderStatusWidget({
    super.key,
    required this.customerName,
    required this.orderNo,
    required this.status,
    required this.estimatedDelivery,
    required this.estimatedCost,
    required  this.model,
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

        _buildStatusDot('PENDING', model.status=="PENDING"),
        _buildStatusDot('CONFIRMED', model.status=="CONFIRMED"),
        _buildStatusDot('CANCELLED',model.status=="CANCELLED"),
        _buildStatusDot('FULFILLED', model.status=="FULFILLED"),
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
        Text('Customer: $customerName'),
        const SizedBox(height: 8),
        Text('Order No: $orderNo'),
        const SizedBox(height: 8),
        Text('Status: $status'),
        const SizedBox(height: 8),
        Text('Estimated Delivery Time: ${_formatDateTime(estimatedDelivery)}'),
        const SizedBox(height: 8),
        Text('Estimated Cost: ${estimatedCost.toStringAsFixed(0)} ksh'),
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
