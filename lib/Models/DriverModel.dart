class Drivermodel {
  final dynamic truck;
  final dynamic phone;
  final dynamic avaiable;
  final dynamic status;

  Drivermodel({
    required this.truck,
    required this.phone,
    required this.avaiable,
    required this.status,
  });

  factory Drivermodel.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      if (value == null) {
        print('The value for $key is null');
      }
    });
 

    return Drivermodel(
      truck: json["truck"],
      phone: json["phone"],
      avaiable: json["avaiable"],
      status: json["status"],
    );
  }
}
