class Ordermodel {
  final String status;
  final String name;
  final dynamic id;
  final dynamic deliveryDate;
  final dynamic price;

  Ordermodel({
    required this.status,
    required this.name,
    required this.id,
    required this.deliveryDate,
    required this.price,
  });

  factory Ordermodel.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      if (value == null) {
        print('The value for $key is null');
      }
    });

    if (json["status"] == null || 
        json["name"] == null || 
        json["id"] == null || 
        json["deliveryDate"] == null || 
        json["price"] == null) {
      throw Exception("Missing required fields in the JSON data.");
    }

    return Ordermodel(
      status: json["status"],
      name: json["name"],
      id: json["id"],
      deliveryDate: json["deliveryDate"],
      price: json["price"],
    );
  }
}
