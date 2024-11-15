import '../../../Models/Wsp.dart';
import '../../../comms/Req.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
        child: FutureBuilder<List<WspModel>>(
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
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
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
                    width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                    Icon(Icons.water_drop, color: Color(0xFF7E64D4)),
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
                                    _buildDetailRow(Icons.source, 'Source', details.source),
                                    _buildDetailRow(Icons.water, 'Quality', details.quality),
                                    // _buildDetailRow(Icons.location_on, 'Location', 
                                    //   '${details.lat}, ${details.lon}'),
                                    _buildDetailRow(Icons.home, 'Address', details.address),
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
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Color(0xFF7E64D4).withOpacity(0.1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        bool isLastItem = rate == details.rates.last;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: !isLastItem
                ? Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              // Capacity Section
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF7E64D4).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.local_shipping,
                        color: Color(0xFF7E64D4),
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${rate.truckC} Liters',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Truck Capacity',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Price Section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF7E64D4).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'KSH ',
                      style: TextStyle(
                        color: Color(0xFF7E64D4),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${rate.truckCp}',
                      style: TextStyle(
                        color: Color(0xFF7E64D4),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
      // Footer with average price
      Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFF7E64D4).withOpacity(0.05),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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