import 'dart:convert';

import 'package:application/Models/Wsp.dart';
import 'package:application/comms/Req.dart';
import 'package:application/comms/credentials.dart';
import 'package:application/views/widgets/WSP/homepage/wspglobals.dart';
import 'package:cherry_toast/cherry_toast.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';

class WspDetailsScreen extends StatefulWidget {
  @override
  _WspDetailsScreenState createState() => _WspDetailsScreenState();
}

class _WspDetailsScreenState extends State<WspDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "WSP Details",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
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
        child: FutureBuilder<List<WsProviders>>(
          future: AppRequest.fetchWSP(),
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
                    child: ErrorState(
                        context: context,
                        error: "No WSPs found",
                        function: () {})),
              );
            } else if (snapshot.hasData) {
              final wspDetails = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(top: 100, bottom: 20),
                itemCount: wspDetails.length,
                itemBuilder: (context, index) {
                  final details = wspDetails[index];
                  return Container(
                    width: MediaQuery.of(context).size.width *
                        0.9, // 90% of screen width
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.9),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Header with WSP Name
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Color(0xFF7E64D4).withOpacity(0.1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.water_drop,
                                        color: Color(0xFF7E64D4)),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        details.wspName,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF7E64D4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Details Section
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailRow(
                                        Icons.source, 'Source', details.source),
                                    _buildDetailRow(Icons.water, 'Quality',
                                        details.quality),
                                    // _buildDetailRow(Icons.location_on, 'Location',
                                    //   '${details.lat}, ${details.lon}'),
                                    _buildDetailRow(
                                        Icons.home, 'Address', details.address),
                                    SizedBox(height: 16),
                                    // Rates Section
                                    Text(
                                      'Available Rates',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF7E64D4),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Header
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF7E64D4)
                                                  .withOpacity(0.1),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Capacity',
                                                  style: TextStyle(
                                                    color: Color(0xFF7E64D4),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  'Price',
                                                  style: TextStyle(
                                                    color: Color(0xFF7E64D4),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Rates List
                                          ...details.rates.map((rate) {
                                            bool isLastItem =
                                                rate == details.rates.last;
                                            return ListTile(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                              leading: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF7E64D4)
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  Icons.local_shipping,
                                                  color: Color(0xFF7E64D4),
                                                  size: 20,
                                                ),
                                              ),
                                              title: Text(
                                                '${rate.truckC} Liters',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              subtitle: Text(
                                                'Truck Capacity',
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              trailing: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF7E64D4)
                                                      .withOpacity(0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  'KSH ${rate.truckCp}',
                                                  style: TextStyle(
                                                    color: Color(0xFF7E64D4),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Rate Details',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  0xFF7E64D4),
                                                            ),
                                                          ),
                                                          SizedBox(height: 16),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  'Truck Capacity:',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              Text(
                                                                  '${rate.truckC} Liters'),
                                                            ],
                                                          ),
                                                          SizedBox(height: 8),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text('Price:',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              Text(
                                                                  'KSH ${rate.truckCp}'),
                                                            ],
                                                          ),
                                                          SizedBox(height: 16),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                    'Close'),
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xFF7E64D4),
                                                                ),
                                                                onPressed: () {
                                                                  final jsonString =
                                                                      jsonEncode({
                                                                    "selectedWsp":
                                                                        details
                                                                            .wspId,
                                                                    "truckCapacity":
                                                                        rate.truckC,
                                                                    "capacityPrice":
                                                                        rate.truckCp
                                                                  });

                                                                  comms_repo.QueryAPIpost(
                                                                          "fp/order",
                                                                          jsonString,
                                                                          context)
                                                                      .then(
                                                                          (value) {
                                                                    print(
                                                                        "##########$value");
                                                                    if (value[
                                                                        "success"]) {
                                                                      CherryToast
                                                                          .success(
                                                                            toastDuration: Duration(seconds: 5),
                                                                        title: Text(
                                                                            "Success"),
                                                                        description: Text(value["data"]
                                                                            .toString()
                                                                            .replaceAll("{",
                                                                                "")
                                                                            .replaceAll("}",
                                                                                "")),
                                                                      ).show(
                                                                          context);

                                                                      Navigator.pop(
                                                                          context);
                                                                    } else {
                                                                      print(value[
                                                                          "msg"]);
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  });
                                                                },
                                                                child: Text(
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                            color:
                                                                                Colors.white),
                                                                    'Order'),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          }).toList(), // Footer with average price
                                          Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF7E64D4)
                                                  .withOpacity(0.05),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(15),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Average Price: ',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  'KSH ${_calculateAveragePrice(details.rates)}',
                                                  style: TextStyle(
                                                    color: Color(0xFF7E64D4),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'No data available',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
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

String _calculateAveragePrice(List<Rates> rates) {
  if (rates.isEmpty) return '0.00';
  double total = 0;
  for (var rate in rates) {
    total += double.parse(rate.truckCp);
  }
  return (total / rates.length).toStringAsFixed(2);
}
