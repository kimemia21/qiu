class trucksmodel {
  final String id;
  final capacity;
  final String quality;
  final String reg;


  trucksmodel({
    required this.id,
    required this.capacity,
    required this.quality,
    required this.reg,
  });


  factory trucksmodel.fromJson(Map<String, dynamic> json) {
    // Check for null values in required fields
    if (json['id'] == null ||
        json['capacity'] == null ||
        json['quality'] == null ||
        json['reg'] == null) {
      throw ArgumentError('One or more required fields are null');
    }

    return trucksmodel(
      id: json['id'],
      capacity: (json['capacity']),
      quality: json['quality'],
      reg: json['reg'],
    );
  }
}
