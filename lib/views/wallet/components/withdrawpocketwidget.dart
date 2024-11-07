import 'package:flutter/material.dart';

import '../../../Models/walletmodel.dart';
import '../../../utils/colors.dart';

class PocketWithdrwaCardWidget extends StatelessWidget {
  final Pocket wallet;

  const PocketWithdrwaCardWidget({
    required this.wallet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.black87),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.indexcolor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              'Book Balance',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
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
            SizedBox(height: 10),
            Text(
              'Withdrawable Amount',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${wallet.accountBalance}', // Replace with actual card type
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "(${wallet.currency})",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  wallet.pocketName,
                  style: TextStyle(
                    letterSpacing: 3,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
