class Numbers {
  int? id;
  String? phoneNumber;
  bool? isDefault;
  String? createdOn;

  Numbers({
    this.id,
    this.phoneNumber,
    this.isDefault,
    this.createdOn,
  });
  Numbers.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    phoneNumber = json['phoneNumber']?.toString();
    isDefault = json['isDefault'];
    createdOn = json['createdOn']?.toString();
  }
}

class MpesaNumbers {
  String? message;
  int? numberOfPhoneNumbers;
  List<Numbers?>? numbers;

  MpesaNumbers({
    this.message,
    this.numberOfPhoneNumbers,
    this.numbers,
  });
  MpesaNumbers.fromJson(Map<String, dynamic> json) {
    message = json['message']?.toString();
    numberOfPhoneNumbers = json['numberOfPhoneNumbers']?.toInt();
    if (json['numbers'] != null) {
      final v = json['numbers'];
      final arr0 = <Numbers>[];
      v.forEach((v) {
        arr0.add(Numbers.fromJson(v));
      });
      numbers = arr0;
    }
  }
}
