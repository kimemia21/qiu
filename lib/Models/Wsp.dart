

class WspModel {
  final int wspId;
  final String wspName;
  final String source;
  final String quality;
  final double lat;
  final double lon;
  final String address;
  final List<Rates> rates;

  WspModel(
      {required this.wspId,
      required this.wspName,
      required this.source,
      required this.quality,
      required this.lat,
      required this.lon,
      required this.address,
      required this.rates});

  factory WspModel.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      if (value == null) {
        print('Null value found for key: $key');
      }
    });

    final List jrates = json["rates"];

    final List<Rates> rates = jrates.map((e) => Rates.fromJson(e)).toList();

    return WspModel(
        wspId: json["wspId"],
        wspName: json["wspName"],
        source: json["source"],
        quality: json["quality"],
        lat: json["lat"],
        lon: json["lon"],
        address: json["address"],
        rates: rates);
  }
}

class Rates {
  final truckC;
  final truckCp;
  Rates({required this.truckC, required this.truckCp});

  factory Rates.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      if (value == null) {
        print('Null value found for key: $key');
      }
    });
    return Rates(truckC: json["truckCapacity"], truckCp: json["capacityPrice"]);
  }
}
