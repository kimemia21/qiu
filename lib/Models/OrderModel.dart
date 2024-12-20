class OrderModel {
  final String orderStatus;
  final String? driverName;
  final String orderId;
  final int orderCapacity;
  final double? orderAmount;
  final DateTime? orderDate;
  final String paymentStatus;
  final String? wspCompanyName;
  final String? wpWaterSrc;
  final String? wspAdrress;

  OrderModel({
    required this.orderStatus,
    this.driverName,
    required this.orderId,
    required this.orderCapacity,
    required this.orderAmount,
    this.orderDate,
    required this.paymentStatus,
    this.wspCompanyName,
    this.wpWaterSrc,
    this.wspAdrress,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    if (json['details'] == null) {
      throw Exception("Missing 'details' field in the JSON data.");
    }

    final details = json['details'] as Map<String, dynamic>;

 

    return OrderModel(
  orderStatus: (json['orderStatus'] ?? json['status'] ?? "") as String,
  driverName: details['driverName']?.toString() ?? "",
  orderId: json['orderId']?.toString() ?? "",
  orderCapacity: int.tryParse(details['orderCapacity'] ?? details['capacity'] ?? "") ?? 0,
  orderAmount: double.tryParse(details['orderAmount']?.toString() ?? "") ?? 0.0,
  orderDate: details['orderDate'] != null 
      ? DateTime.tryParse(details['orderDate']) 
      : null,
  paymentStatus: details['paymentStatus']?.toString() ?? "",
  wspCompanyName: details['wspCompanyName']?.toString() ?? "",
  wpWaterSrc: details['wpWaterSrc']?.toString() ?? "",
  wspAdrress: details['wspAdrress']?.toString() ?? "",
);

  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     "orderStatus": orderStatus,
  //     "orderId": orderId,
  //     "details": {
  //       "driverName": driverName,
  //       "orderCapacity": orderCapacity.toString(),
  //       "orderAmount": orderAmount.toStringAsFixed(2),
  //       "orderDate": orderDate.toIso8601String(),
  //       "paymentStatus": paymentStatus,
  //     },
  //   };
  // }
}
