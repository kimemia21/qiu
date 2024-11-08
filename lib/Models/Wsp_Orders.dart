import 'dart:convert';

class WspOrders {
  String orderId;
  String status;
  String capacity;
  String orderAmount;
  String paymentStatus;
  String wspCompanyName;
  String wpWaterSrc;
  String wspAddress;

  WspOrders({
    required this.orderId,
    required this.status,
    required this.capacity,
    required this.orderAmount,
    required this.paymentStatus,
    required this.wspCompanyName,
    required this.wpWaterSrc,
    required this.wspAddress,
  });

  factory WspOrders.fromJson(Map<String, dynamic> json) {
    return WspOrders(
      orderId: json['orderId'],
      status: json['status'],
      capacity: json['capacity'],
      orderAmount: json['orderAmount'],
      paymentStatus: json['paymentStatus'],
      wspCompanyName: json['wspCompanyName'],
      wpWaterSrc: json['wpWaterSrc'],
      wspAddress: json['wspAdrress'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'status': status,
      'capacity': capacity,
      'orderAmount': orderAmount,
      'paymentStatus': paymentStatus,
      'wspCompanyName': wspCompanyName,
      'wpWaterSrc': wpWaterSrc,
      'wspAdrress': wspAddress,
    };
  }
}