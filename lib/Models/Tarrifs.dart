class TarrifsModel {
  final int Id;
  final String truckCapacity;

  final String capacityPrice;

  const TarrifsModel(
      {required this.Id,
      required this.capacityPrice,
      required this.truckCapacity});

  factory TarrifsModel.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      if (value == null) {
        print(' TarrifsModel The value for $key is null');
      }
    });


    return TarrifsModel(
        Id: json["id"],
        capacityPrice: json["capacityPrice"],
        truckCapacity: json["truckCapacity"]);
  }
}
