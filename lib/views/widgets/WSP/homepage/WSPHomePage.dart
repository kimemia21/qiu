import 'package:application/Authentication/loginPage.dart';
import 'package:application/Models/AccountTypes.dart';
import 'package:application/Models/OrderModel.dart';
import 'package:application/Models/Tarrifs.dart';
import 'package:application/comms/Req.dart';
import 'package:application/comms/credentials.dart';
import 'package:application/utils/utils.dart';
import 'package:application/views/widgets/Orders/orders.dart';
import 'package:application/views/widgets/WSP/homepage/wspglobals.dart';
import 'package:application/views/widgets/WSP/homepage/wsptarrif.dart';
import 'package:application/views/widgets/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

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

  void refreshTarrifs() {
    print("mems");
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
      appBar: AppBar(
        backgroundColor: appGradient[0],
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Water Utility Service Provider',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                //  just pushing the user to the login screen  but no server side logout is happening
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
                // AppRequest.logout();
              } else if (value == 'refresh') {
                refreshTarrifs();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              _buildPopupMenuItem('refresh', 'Refresh', Icons.refresh),
              _buildPopupMenuItem('logout', 'Logout', Icons.logout,
                  isDestructive: true),
            ],
          ),
        ],
      ),
      backgroundColor: Color(0xFF7E64D4),
      body: SafeArea(
        child: Container(
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                      vertical: 16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Header Section
                        SvgPicture.asset(
                          'assets/images/Logo.svg',
                          height: MediaQuery.of(context).size.height * 0.08,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Text(
                          'Your end to end water utility App',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white70,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Text(
                          'Buy. Manage. Monitor',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),

                        // Tariffs Section
                        Container(
                          width: double.infinity,
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
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await showWSPModals(
                                      context: context,
                                      capcityController:
                                          TextEditingController(),
                                      priceController: TextEditingController(),
                                      isCreate: true,
                                    );
                                    refreshTarrifs();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade400,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add,
                                          size: 18, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text('Add'),
                                    ],
                                  ),
                                ),
                              ),
                              FutureBuilder<List<TarrifsModel>>(
                                future: _tarriffsFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return _buildLoadingState(
                                        'Loading Tariffs...');
                                  } else if (snapshot.hasError) {
                                    return ErrorState(
                                      context: context,
                                      error: snapshot.error.toString(),
                                      function: () {
                                        setState(() {
                                          _tarriffsFuture =
                                              AppRequest.fetchWspTarrifs();
                                        });
                                      },
                                    );
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return EmptyState(type: "Tarrifs");
                                  }
                                  return WspTarrifs(
                                      tarrifsModel: snapshot.data!,
                                      callback: () {
                                        print("triggeredddddd");

                                        refreshTarrifs();
                                      });
                                },
                              ),
                            ],
                          ),
                        ),

                        // Orders Section
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4,
                            child: FutureBuilder<List<OrderModel>>(
                              future: AppRequest.fetchOrders(false),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return _buildLoadingState(
                                      'Loading Orders...');
                                } else if (snapshot.hasError) {
                                  return ErrorState(
                                    context: context,
                                    error: snapshot.error.toString(),
                                    function: () {},
                                  );
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return EmptyState(type: "Orders");
                                }
                                return AppOrders();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(String message) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7E57C2)),
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
