class FpDriverTracker {
  final String fulfillmentPartner; // ID of the FP
  final String driver;             // ID of the driver
  final double lat;                // Latitude of the driver
  final double long;               // Longitude
  final int status;                // 1 or 0
  final double capacity;           // Driver truck capacity
  final double price;              // Truck price
  final String vehicleId;          // Truck licence plate
  final DateTime updatedOn;        // Current timestamp

  // Constructor
  FpDriverTracker({
    required this.fulfillmentPartner,
    required this.driver,
    required this.lat,
    required this.long,
    required this.status,
    required this.capacity,
    required this.price,
    required this.vehicleId,
    required this.updatedOn,
  });

  // Factory constructor to create an instance from JSON
  factory FpDriverTracker.fromJson(Map<String, dynamic> json) {
    return FpDriverTracker(
      fulfillmentPartner: json['fulfillmentPartner'] as String,
      driver: json['driver'] as String,
      lat: (json['lat'] as num).toDouble(),
      long: (json['long'] as num).toDouble(),
      status: json['status'] as int,
      capacity: (json['capacity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      vehicleId: json['vehicleId'] as String,
      updatedOn: DateTime.parse(json['updatedOn'] as String),
    );
  }

  // Convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'fulfillmentPartner': fulfillmentPartner,
      'driver': driver,
      'lat': lat,
      'long': long,
      'status': status,
      'capacity': capacity,
      'price': price,
      'vehicleId': vehicleId,
      'updatedOn': updatedOn.toIso8601String(),
    };
  }
}
