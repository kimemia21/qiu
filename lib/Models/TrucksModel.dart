class Trucksmodel {
  final int id;
  final capacity;

  final String licence_plate;
  final String Price;
  final String quality;

  Trucksmodel({
    required this.id,
    required this.Price,
    required this.capacity,
    required this.quality,
    required this.licence_plate,
  });

  factory Trucksmodel.fromJson(Map<String, dynamic> json) {
    // Check for null values in required fields
    if (json['id'] == null ||
        json['capacity'] == null ||
        json['quality'] == null ||
        json['licence_plate'] == null) {
      throw ArgumentError('One or more required fields are null');
    }

    return Trucksmodel(
      id: json['id'],
      licence_plate: json['licence_plate'],
      capacity: (json['capacity']),
      Price: json['price'],
      quality: json['quality'],
    );
  }
}
