import 'package:application/Models/AccountTypes.dart';
import 'package:application/Models/OrderModel.dart';
import 'package:application/Models/Tarrifs.dart';
import 'package:application/comms/Req.dart';
import 'package:application/comms/credentials.dart';
import 'package:application/utils/utils.dart';
import 'package:application/views/widgets/Fps/homepage/infocard.dart';
import 'package:application/views/widgets/Orders/orders.dart';
import 'package:application/views/widgets/WSP/homepage/wspglobals.dart';
import 'package:application/views/widgets/WSP/homepage/wsptarrif.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class WSPHomePage extends StatefulWidget {
  @override
  State<WSPHomePage> createState() => _WSPHomePageState();
}

class _WSPHomePageState extends State<WSPHomePage> {
  Accountypes? accounttype;
  bool saving = false;

  late Future<List<TarrifsModel>> _tarriffsFuture;

  @override
  void initState() {
    super.initState();
    _tarriffsFuture = AppRequest.fetchWspTarrifs();
  }

  // Add method to refresh data when needed
  void refreshTarrifs() {
    setState(() {
      _tarriffsFuture = AppRequest.fetchWspTarrifs();
    });
  }

  PopupMenuItem<String> _buildPopupMenuItem(
      String value, String text, IconData icon,
      {bool isDestructive = false}) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: isDestructive ? Colors.red[400] : Colors.grey[700],
          ),
          SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: isDestructive ? Colors.red[400] : Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,

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
        child: Column(children: [
          Expanded(
            flex: 45,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  const SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Color(0xFFF5F5F5)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF7E57C2).withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            // Add setState here to retry the future
                            await showWSPModals(
                                context: context,
                                capcityController: TextEditingController(),
                                priceController: TextEditingController(),
                                isCreate: true);
                            refreshTarrifs();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade400,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text('Add'),
                            ],
                          ),
                        ),
                        FutureBuilder<List<TarrifsModel>>(
                          future: _tarriffsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF7E57C2)),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Loading Tariffs...',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return ErrorState(
                                  context: context,
                                  error: snapshot.error.toString(),
                                  function: () {});
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return EmptyState(type: "Tarrifs");
                            } else {
                              final List<TarrifsModel> tarrifsModel =
                                  snapshot.data!;
                              return WspTarrifs(tarrifsModel: tarrifsModel);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 30,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 4,
                        child: FutureBuilder<List<Ordermodel>>(
                          future: AppRequest.fetchOrders(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF7E57C2)),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Loading Orders...',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return ErrorState(
                                  context: context,
                                  error: snapshot.error.toString(),
                                  function: () {});
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return EmptyState(type: "Orders");
                            } else {
                              final List<Ordermodel> orderModel =
                                  snapshot.data!;
                              return  WspOrders(orders: orderModel);
                            }
                          },
                        ),
                      ))
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
