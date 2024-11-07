import 'dart:convert';

import '../comms/credentials.dart';
import '../utils/utils.dart';

class Pocket {
  final String pocketId;
  final String gate;
  final String pocketName;
  final String pocketAccount;
  final String pocketBank;
  final String pocketBankBranch;
  final String pocketSwiftCode;
  final double accountBalance;
  final double withdrawableAmount;

  final String pocketStatus;
  final String currency;

  Pocket({
    required this.pocketId,
    required this.gate,
    required this.pocketName,
    required this.pocketAccount,
    required this.pocketBank,
    required this.pocketBankBranch,
    required this.pocketSwiftCode,
    required this.accountBalance,
    required this.withdrawableAmount,
    required this.pocketStatus,
    required this.currency,
  });

  factory Pocket.fromJson(Map<String, dynamic> json) {
    printLog("Decipher pocket $json");
    return Pocket(
        pocketId: json['pocket_id'],
        gate: json['gate'] ?? "",
        pocketName: json['pocket_name'] ?? "",
        pocketAccount: json['pocket_account'] ?? "",
        pocketBank: json['pocket_bank'] ?? "",
        pocketBankBranch: json['pocket_bank_branch'] ?? "",
        pocketSwiftCode: json['pocket_swift_code'] ?? "",
        accountBalance:
            double.parse((json['acct_balance'] ?? "0.0").toString()),
        withdrawableAmount:
            double.parse((json['acct_balance'] ?? "0.0").toString()),
        pocketStatus: json['pocket_status'] ?? "",
        currency: json["currency"] ?? "KES");
  }
}

class PocketsResponse {
  final List<Pocket> pockets;
  final String email;
  final String merchantId;

  PocketsResponse({
    required this.pockets,
    required this.email,
    required this.merchantId,
  });

  factory PocketsResponse.fromJson(Map<String, dynamic> json) {
    printLog("Decipher wallet $json");
    List<Pocket> pocketList = (json['wallets'] as List)
        .map((pocketJson) => Pocket.fromJson(pocketJson))
        .toList();
    printLog("Return pockets");

    return PocketsResponse(
      pockets: pocketList,
      email: json['email'] ?? "",
      merchantId: json['merchant_id'] ?? "",
    );
  }
}

enum TransactionIntent { ALL, PAYMENT, DEPOSIT, REFUND }

class WalletTransaction {
  final String trxId;
  final String date;
  final TransactionIntent intent;
  final double amount;
  final String customerId;
  final String customerName;
  final String customerRef;
  final String gate;
  final String status;
  final String description;

  WalletTransaction({
    required this.trxId,
    required this.date,
    required this.intent,
    required this.amount,
    required this.customerId,
    required this.customerName,
    required this.customerRef,
    required this.gate,
    required this.status,
    required this.description,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      trxId: json['trx_ID'],
      date: json['Date'],
      description: json['description'] ?? json['Customer_name'] ?? "",
      intent: _parseIntent(json['Intent'] ?? "".toLowerCase()),
      amount: double.parse(json['Amount']),
      customerId: json['Customer_Id'],
      customerName: json['Customer_name'],
      customerRef: json['Customer_Ref'],
      gate: json['Gate'],
      status: json['Status'],
    );
  }

  static TransactionIntent _parseIntent(String intent) {
    intent = intent.toLowerCase();
    switch (intent) {
      case 'all':
        return TransactionIntent.ALL;
      case 'payment':
        return TransactionIntent.PAYMENT;
      case 'deposit':
        return TransactionIntent.DEPOSIT;
      case 'refund':
        return TransactionIntent.REFUND;
      default:
        return TransactionIntent.ALL;
    }
  }
}

class mpesaRequest {
  bool bool_code = false;
  String trx_id = "";
  String message = "";

  mpesaRequest({
    this.bool_code = false,
    this.trx_id = "",
    this.message = "",
  });

  factory mpesaRequest.fromMap(json) {
    printLog("break " + json.toString());

// break [{bool_code: TRUE, message: Request Successfully Processed, trx_id: ws_CO_08062022125029199721374510}]

// Got Mpesa Rsponsse 200  [{bool_code: TRUE, message: Request Successfully Processed, trx_id: ws_CO_19102023024826053721374510}, {account_number: nueo4LkKG8yGp7KuQrqi}]
    return mpesaRequest(
      trx_id: json[1]["account_number"],
      message: json[0]["message"],
      bool_code: json[0]["bool_code"].toString().trim().toUpperCase() == "TRUE",
    );
  }
  Map<String, dynamic> toMap() => {};
  mpesaRequest fromJson(String str) {
    final jsonData = json.decode(str);
    return mpesaRequest.fromMap(jsonData);
  }

  String toJson(mpesaRequest data) {
    printLog("Print mepsa request model ");
    final dyn = data.toMap();
    return json.encode(dyn);
  }

  Map<String, dynamic> toJsonMap() => {
        "bool_code": bool_code,
        "trx_id": trx_id,
        "message": message,
      };
}
