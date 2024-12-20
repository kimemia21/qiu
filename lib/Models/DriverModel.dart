// "mems"

class Drivermodel {
  final String driverId;
  final String lastName;

  final dynamic phone;
  final int avaiable;
  final int? isOnline;
  final String firstName;
  // final int? driverFp;
  final String assignedTruck;












  Drivermodel({
    required this.driverId,
    required this.lastName,
    required this.phone,
    required this.avaiable,
    // this is to make this model to be reuseable for both driver and driver profile usage
    //  this.driverFp,
     this.isOnline,
    required this.firstName,
    required this.assignedTruck,
  });

  factory Drivermodel.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      if (value == null) {
        print('The value for $key is null');
      }
    });

    return Drivermodel(
      driverId: json["driverId"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      assignedTruck: json["assignedTruck"],
      phone: json["phone"],
      avaiable: json["isAvailable"],
    //  driverFp: json["driverFp"]??"",
      isOnline: json["isOnline"]??"",
    );
  }
}
