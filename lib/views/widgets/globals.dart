import 'package:application/Models/DriverModel.dart';
import 'package:application/Models/Drivermodel.dart';
import 'package:application/Models/OrderModel.dart';
import 'package:application/main.dart';
import 'package:application/views/state/appbloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
        keyboardType: (widget.isPassword ?? false)
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        enableSuggestions: (widget.isPassword ?? false) ? false : true,
        autocorrect: (widget.isPassword ?? false) ? false : true,
        obscureText: hidepass,
        controller: widget.myController,
        decoration: InputDecoration(
          suffixIcon: (widget.isPassword ?? false)
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
  Appbloc bloc = context.watch<Appbloc>();

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
        child: bloc.isLoading?
        Center(
        child: LoadingAnimationWidget.stretchedDots(
         color: Colors.white,
          size: 30,
        ),):
      


         Stack(
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

List<Map<String, dynamic>> dummyTrucksData = [
  {
    "id": 1,
    "licence_plate": "KBC 1234",
    "capacity": "10000",
    "price": "10000",
    "quality": "1"
  },
  {
    "id": 2,
    "licence_plate": "KCC 1234",
    "capacity": "5000",
    "price": "500",
    "quality": "1"
  }
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
