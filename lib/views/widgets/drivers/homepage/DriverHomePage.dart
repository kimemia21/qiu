import 'package:application/views/widgets/WSP/wsp_orders.dart';

import '../../../../utils/utils.dart';
import '../../../OnBoardScreen.dart';
import '../../../loginPage.dart';
import '../../Orders/orders.dart';
import '../drivers.dart';
import '../../globals.dart';
import '../../trucks/Trucks.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class DriverHomepage extends StatefulWidget {
  const DriverHomepage({super.key});

  @override
  State<DriverHomepage> createState() => _DriverHomepageState();
}

class _DriverHomepageState extends State<DriverHomepage> {
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

          // White rounded container that stays fixed
          Positioned(
            top: 200, // Adjust this value to position the white container
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

          // Profile image that stays fixed
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipOval(
                    child: Image.network(
                      "https://imgix.ranker.com/list_img_v2/8131/3168131/original/3168131?fit=crop&fm=pjpg&q=80&dpr=2&w=1200&h=720",
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scrollable content
          Positioned(
            top:
                250, // Should match the white container's top position + some padding
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sasa Stark',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'sansa@example.com',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      margin: EdgeInsets.all(10),
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius:
                            BorderRadiusDirectional.all(Radius.circular(20)),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.details_outlined),
                        title: Text("Account Description"),
                        subtitle: Text("Account SubTitle"),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'My DashBoard',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    CustomMenuItem(
                      dense: true,
                      text: 'Home',
                      icon: Icons.home_outlined,
                      onPressed: () {
                        // Handle navigation
                      },
                      iconColor: Theme.of(context).primaryColor,
                    ),
                    CustomMenuItem(
                      dense: true,
                      text: 'Manage My Orders',
                      icon: Icons.list_alt_outlined,
                      onPressed: () {
                        PersistentNavBarNavigator.pushNewScreen(
                            withNavBar: true, context, screen: OrdersScreen());
                      },
                      iconColor: Theme.of(context).primaryColor,
                    ),
                    if ((current_role == "FP") || (current_role == "DR"))
                      CustomMenuItem(
                        dense: true,
                        text: 'My Trucks',
                        icon: Icons.local_shipping_outlined,
                        onPressed: () {
                          PersistentNavBarNavigator.pushNewScreen(
                              withNavBar: true, context, screen: Trucks());
                        },
                        iconColor: Theme.of(context).primaryColor,
                      ),
                    if ((current_role == "FP") || (current_role == "DR"))
                      CustomMenuItem(
                        dense: true,
                        text: 'My Drivers',
                        icon: Icons.person_outline,
                        onPressed: () {
                          PersistentNavBarNavigator.pushNewScreen(
                              withNavBar: true, context, screen: Drivers());
                          // Handle navigation to My Drivers
                        },
                        iconColor: Theme.of(context).primaryColor,
                      ),
                    CustomMenuItem(
                      dense: true,
                      text: 'FAQs & Support',
                      icon: Icons.help_outline,
                      onPressed: () {
                        // Handle navigation to FAQs & Support
                      },
                      iconColor: Theme.of(context).primaryColor,
                    ),
                    if (current_role == "SC")
                      CustomMenuItem(
                        dense: true,
                        text: 'Change to Service Provider',
                        icon: Icons.settings_outlined,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => OnBoardScreen()));
                        },
                        iconColor: Theme.of(context).primaryColor,
                      ),
                    CustomMenuItem(
                      dense: true,
                      text: 'Account Settings',
                      icon: Icons.settings_outlined,
                      onPressed: () {
                        // Handle navigation to Account Settings
                      },
                      iconColor: Theme.of(context).primaryColor,
                    ),
                    CustomMenuItem(
                      dense: true,
                      text: 'Logout',
                      icon: Icons.logout,
                      onPressed: () {
                        PersistentNavBarNavigator.pushNewScreen(
                            withNavBar: false, context, screen: LoginPage());

                        // Navigator.pushReplacement(context,
                        //     MaterialPageRoute(builder: (context) => P));

                        // Handle navigation to Account Settings
                      },
                      iconColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
