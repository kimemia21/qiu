import 'package:application/Models/OrderModel.dart';
import 'package:application/views/widgets/globals.dart';

class AppRequest {
  static Future<List<Ordermodel>> fetchOrders() {
    final   orders =
        dummyData.map((orders) => Ordermodel.fromJson(orders)).toList();
    return Future.value(orders);
  }
}
