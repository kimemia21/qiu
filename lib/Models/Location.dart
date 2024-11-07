class LocationModel {
  final String place;
  final double lng;
  final double lat;
  final String description;

  LocationModel(
      {required this.lng,
      required this.lat,
      required this.description,
      required this.place});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      if (key == null) {
        print('The value for $value is null');
      }
      if (value == null) {
        print('The value for $key is null');
      }
    });

    return LocationModel(
        lng: json["lng"],
        lat: json["lat"],
        description: json["description"],
        place: json["place"]);
  }
}
