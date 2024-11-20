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
      orderStatus: json['orderStatus'??"status"] as String,
      driverName: details['driverName'] as String ??null,
      orderId: json['orderId'] as String,
      orderCapacity: int.parse(details['orderCapacity'??"capacity"] as String),
      orderAmount: double.parse(details['orderAmount'] as String),
      orderDate: DateTime.parse(details['orderDate'] ??null),
      paymentStatus: details['paymentStatus'] as String,
      wspCompanyName: details['wspCompanyName'] as String ??null,
      wpWaterSrc: details['wpWaterSrc'] as String ??null,
      wspAdrress: details['wspAdrress'] as String ??null,
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
