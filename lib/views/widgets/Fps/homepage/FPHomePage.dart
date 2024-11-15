import '../../../../Models/AccountTypes.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets.dart';
import '../../../login.dart';

import '../../globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../trucks/Trucks.dart';
import '../../trucks/createTruck.dart';
import 'infocard.dart';

class FPHomePage extends StatefulWidget {
  @override
  State<FPHomePage> createState() => _FPHomePageState();
}

class _FPHomePageState extends State<FPHomePage> {
  Accountypes? accounttype;
  TextEditingController address = TextEditingController();
  TextEditingController source = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController quality = TextEditingController();
  String lat = "";
  String long = "";
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7E64D4),
              Color(0xFF9DD6F8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: 100),
              SvgPicture.asset(
                'assets/images/Logo.svg',
                height: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                'Your end to end water utility App',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Buy. Manage. Monitor',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              Container(
                child: Column(),),

              // Trucks Card
              InfoCard(
                title: 'Trucks',
                count: "34",
                icon: Icons.local_shipping,
                color: Colors.blue,
                tapped: () async {
                  printLog("tapped Trucks");

                  // await CreateNewTruck(context);

                  PersistentNavBarNavigator.pushNewScreen(
                      withNavBar: true, context, screen: Trucks());
                },
              ),
              SizedBox(height: 16),
              // Drivers Card
              InfoCard(
                title: 'Drivers',
                count: "3",
                icon: Icons.person,
                color: Colors.green,
                tapped: () {
                  printLog("tapped Drivers");
                },
              ),
              SizedBox(height: 16),
              // Balance Card
              InfoCard(
                title: 'Current Balance',
                count: '\$${4900.toStringAsFixed(2)}',
                icon: Icons.account_balance_wallet,
                color: Colors.orange,
                tapped: () {
                  printLog("tapped Indx balance");
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
