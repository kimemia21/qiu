import 'dart:ui';

import 'package:application/utils/utils.dart';
import 'package:flutter/material.dart';

class IndxCard extends StatelessWidget {
  final GestureTapCallback? tapped;

  const IndxCard({Key? key, required this.tapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapped,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/indxwallet.png",
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              ),

              SizedBox(width: 16),
              // Title and count
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Indx Wallet",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  (currentIndexUser.active!)
                      ? Text(
                          currentIndexUser.wallets!
                              .fold(
                                  0,
                                  (sum, item) =>
                                      sum +
                                      int.parse(item.accountBalance.toString()))
                              .toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        )
                      : Text("Log in")
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
