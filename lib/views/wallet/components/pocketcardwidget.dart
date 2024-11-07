import 'package:flutter/material.dart';

import '../../../Models/walletmodel.dart';
import '../../../comms/credentials.dart';
import '../../../utils/utils.dart';

class PocketCardWidget extends StatelessWidget {
  final int transactionamount;
  final bool istransaction;
  final bool selected;
  final Pocket wallet;
  final Function(Pocket indx, dynamic request, dynamic value) ontransactrequest;

  const PocketCardWidget(
      {required this.transactionamount,
      required this.ontransactrequest,
      required this.istransaction,
      required this.selected,
      required this.wallet});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        printLog("Selected Wallet");
        ontransactrequest(wallet, "SELECTED", transactionamount);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: selected ? Colors.black87 : Colors.white),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: istransaction
                ? (wallet.accountBalance >= transactionamount &&
                        wallet.accountBalance > 0)
                    ? Colors.green[600]
                    : Colors.redAccent
                : Colors.blue, //
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Text(
                'Balance',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${wallet.accountBalance}', // Replace with actual card type
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.monetization_on_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                wallet.currency,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    wallet.pocketName,
                    style: TextStyle(
                      letterSpacing: 3,
                      fontSize: 35,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Center(
                child: GestureDetector(
                    onTap: () async {
                      print(transactionamount);
                      if (transactionamount < 50) {
                        return;
                      }

                      if (istransaction &&
                          wallet.accountBalance >= transactionamount &&
                          wallet.accountBalance > 0) {
                        ontransactrequest(wallet, "DEDUCT", transactionamount);
                      } else {
                        ontransactrequest(wallet, "TOP_UP", transactionamount);
                      }
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 50,
                          color: Colors.white,
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                                istransaction &&
                                        wallet.accountBalance >=
                                            transactionamount &&
                                        wallet.accountBalance > 0
                                    ? "Deduct From Wallet"
                                    : "Top up Wallet",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: istransaction
                                        ? (wallet.accountBalance <=
                                                transactionamount)
                                            ? Colors.red
                                            : Colors.green[900]
                                        : const Color(0xFF0F75BC))),
                          )),
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
