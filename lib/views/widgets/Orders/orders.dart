import 'package:application/Models/OrderModel.dart';
import 'package:application/views/widgets/globals.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OrderStatusWidget(
                      model:Ordermodel,

  customerName: 'Jane Doe',
  orderNo: '27',
  status: 'PENDING',
  estimatedDelivery: DateTime(2024, 4, 20, 11, 5),
  estimatedCost: 5000,
),
OrderStatusWidget(
    model:Ordermodel,
  customerName: 'Jane Doe',
  orderNo: '27',
  status: 'PENDING',
  estimatedDelivery: DateTime(2024, 4, 20, 11, 5),
  estimatedCost: 5000,
)
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