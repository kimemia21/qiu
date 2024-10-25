// "mems"

class drivermodel {
  final dynamic truck;
  final dynamic phone;
  final dynamic avaiable;
  final dynamic status;
  final String name;

  drivermodel({
    required this.truck,
    required this.phone,
    required this.avaiable,
    required this.status,
    required  this.name
  });

  factory drivermodel.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      if (value == null) {
        print('The value for $key is null');
      }
    });

    return drivermodel(
      truck: json["truck"],
      phone: json["phone"],
      avaiable: json["avaiable"],
      status: json["status"],
      name: json["name"]
    );
  }
}
