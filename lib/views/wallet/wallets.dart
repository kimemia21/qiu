import 'package:flutter/material.dart';

import '../../Models/walletmodel.dart';
import '../../comms/credentials.dart';
import '../../utils/colors.dart';
import 'transactwallet.dart';

class WalletCardWidget extends StatefulWidget {
  final List<Pocket> wallets;

  WalletCardWidget({
    required this.wallets,
  });

  @override
  _WalletCardWidgetState createState() => _WalletCardWidgetState();
}

class _WalletCardWidgetState extends State<WalletCardWidget> {
  bool fetchingtransactions = false;
  List<WalletTransaction> recentTransactions = [];

  Pocket? selectedwallet = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      // bottomNavigationBar: const CustomBottomNavigationBar(2),
      extendBody: true,
      body: Stack(
        children: [
          Row(
            children: [
              Container(
                  color: const Color(0xff0A625B),
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width * 0.03),
              Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.97,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      // usercard(context),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset("assets/images/wallet.png"),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.wallets.length == 1
                            ? " My Pockets"
                            : ' My Pockets (${widget.wallets.length})',
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 290,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.wallets!.length,
                          itemBuilder: (context, index) {
                            Pocket wallet = widget.wallets!.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                // getTransactions();
                                setState(() {
                                  selectedwallet = wallet;
                                  recentTransactions = [];
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: selectedwallet == wallet
                                          ? Color(0xfff44621)
                                          : Colors.white),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColors.indexcolor, //
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Text(
                                          'Balance',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                              Icons
                                                  .account_balance_wallet_rounded,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                                onTap: () async {
                                                  await TransactFromWallet(
                                                          context,
                                                          wallet,
                                                          false)
                                                      .then((value) {
                                                    if (value != null) {
                                                      if (value == true) {
                                                        setState(() {});
                                                      }
                                                    }
                                                  });
                                                },
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50.0)),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.35,
                                                      height: 50,
                                                      color: Colors.white,
                                                      child: Center(
                                                          child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Icon(
                                                              Icons.upload,
                                                              color: AppColors
                                                                  .indexcolor,
                                                            ),
                                                            Text("Top up",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: AppColors
                                                                        .indexcolor)),
                                                          ],
                                                        ),
                                                      )),
                                                    ))),
                                            GestureDetector(
                                                onTap: () async {
                                                  selectedwallet = wallet;
                                                  getTransactions();
                                                },
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50.0)),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.35,
                                                      height: 50,
                                                      color: Colors.white,
                                                      child: Center(
                                                          child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Icon(
                                                              Icons.receipt,
                                                              color: AppColors
                                                                  .indexcolor,
                                                            ),
                                                            Text("Transactions",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: AppColors
                                                                        .indexcolor)),
                                                          ],
                                                        ),
                                                      )),
                                                    ))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      if (recentTransactions.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Transactions',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'See all',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      fetchingtransactions
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                      strokeWidth: 2, color: AppColors.appblue),
                                  Text("Loading Transactions...")
                                ],
                              ),
                            )
                          : recentTransactions.isEmpty
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 420,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 5),
                                      if (selectedwallet != null)
                                        Text(
                                          'Account #',
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      SizedBox(height: 5),
                                      if (selectedwallet != null)
                                        Text(
                                          selectedwallet!.pocketAccount,
                                          style: TextStyle(
                                            fontSize: 35,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      Image.asset(
                                        "assets/images/trans.png",
                                        width: 300,
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  height: 420,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemExtent: 50,
                                    itemCount: recentTransactions.length,
                                    itemBuilder: (context, index) {
                                      WalletTransaction transaction =
                                          recentTransactions[index];

                                      return ListTile(
                                        leading: Container(
                                          width: 80,
                                          height: 40,
                                          // padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: transaction.intent ==
                                                    TransactionIntent.DEPOSIT
                                                ? AppColors.indexcolor
                                                : Colors.red.shade900, //
                                          ),
                                          child: true
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        transaction.intent
                                                            .toString()
                                                            .replaceAll(
                                                                "TransactionIntent.",
                                                                "")
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.white)),
                                                    Icon(
                                                      transaction.intent ==
                                                              TransactionIntent
                                                                  .DEPOSIT
                                                          ? Icons.arrow_downward
                                                          : Icons.arrow_upward,
                                                      color: transaction
                                                                  .intent ==
                                                              TransactionIntent
                                                                  .DEPOSIT
                                                          ? Colors.green
                                                          : Colors.red,
                                                      size: 20,
                                                    )
                                                  ],
                                                )
                                              : Icon(
                                                  transaction.intent ==
                                                          TransactionIntent
                                                              .DEPOSIT
                                                      ? Icons.arrow_downward
                                                      : Icons.arrow_upward,
                                                  color: transaction.intent ==
                                                          TransactionIntent
                                                              .DEPOSIT
                                                      ? Colors.green
                                                      : Colors.red,
                                                  size: 20,
                                                ),
                                        ),
                                        title: Text(transaction.description,
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.black87)),
                                        subtitle: Text(
                                          transaction.date,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black87),
                                        ),
                                        trailing: Text(
                                          "KES ${transaction.amount}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: transaction.intent ==
                                                    TransactionIntent.DEPOSIT
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Positioned(
          //   bottom: 20,
          //   right: 20,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       // Implement top-up wallet functionality
          //     },
          //     style: ElevatedButton.styleFrom(
          //       primary: AppColors.appblue,
          //     ),
          //     child: Padding(
          //       padding: EdgeInsets.all(10.0),
          //       child: Text(
          //         'Top Up Wallet',
          //         style: TextStyle(
          //           fontSize: 18,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  void getTransactions() async {
    setState(() {
      fetchingtransactions = true;
    });

    recentTransactions = await comms_repo.getWalletTransactions();
    setState(() {
      fetchingtransactions = false;
    });
  }
}
