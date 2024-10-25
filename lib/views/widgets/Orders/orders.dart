import 'package:application/Models/OrderModel.dart';
import 'package:application/views/widgets/globals.dart';
import 'package:application/views/widgets/request/Req.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  void initState() {
    super.initState();
  }

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

          Positioned(
            top: 100,
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

          Positioned(
            top: 120,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FutureBuilder<List<Ordermodel>>(
                  future: AppRequest.fetchOrders(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Ordermodel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Error: ${snapshot.error}')); // Show error if any
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No Orders Available')); // Show message if no data
                    }

                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(), // Prevent scrolling within the ListView itself
                      shrinkWrap: true, // Ensure the ListView only takes up as much space as needed
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final order = snapshot.data![index];
                        return OrderStatusWidget(model: order); // Custom widget
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
