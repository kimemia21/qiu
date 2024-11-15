import 'dart:convert';
import 'dart:io';
import '../../utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import '../../Models/walletmodel.dart';
import '../../comms/credentials.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import 'components/pocketcardwidget.dart';
import 'components/processing.dart';
import 'walletspage.dart';

Future<dynamic> TransactFromWallet(
    BuildContext context, Pocket? walle, bool isdeducttransaction) async {
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Row(
            children: [
              Container(
                  color: const Color(0xff0A625B),
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width * 0.05),
              Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: WalletTransact(
                      wallet: walle, isdeducttransaction: isdeducttransaction)),
            ],
          )));
}

class WalletTransact extends StatefulWidget {
  const WalletTransact(
      {Key? key, this.wallet, required this.isdeducttransaction})
      : super(key: key);

  final Pocket? wallet;
  final bool isdeducttransaction;
  @override
  State<WalletTransact> createState() => _WalletTransactState();
}

class _WalletTransactState extends State<WalletTransact> {
  FocusNode field_focus = FocusNode();

  late TextEditingController mpesaNoTxtEditingController,
      desccontroller,
      amounttextcontroller;
  bool sendmpesa = false;
  bool ispurchasing = false;
  int due = 0; // = widget.charge;
  String mpesaresponse = "Waiting for Command..";
  bool cantransact = false;
  String phoneNumber = '';
  bool topupnow = false;
  mpesaRequest mpesarequest = mpesaRequest();
  bool loadingwallets = false;
  PaymentOption? selectedOption;
  String state = "canrequest";
  String statedesc = "";
  List<Pocket> wallets = [];
  Pocket? selectedwallet = null;

  @override
  void initState() {
    // ispurchasing = selectedwallet == null;
    mpesaNoTxtEditingController = TextEditingController();
    amounttextcontroller = TextEditingController();
    desccontroller = TextEditingController();
    super.initState();
    printLog("Phoennno ${rawPhone}");
    mpesaNoTxtEditingController.text = rawPhone;
    field_focus.requestFocus();
    if (widget.wallet != null) {
      selectedwallet = widget.wallet;
    }
    desccontroller.text = "Meter:";

    loadWallets();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        // heightFactor: 2,
        widthFactor: 0.9,
        child: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
          padding: EdgeInsets.only(
              left: 4.0,
              right: 4.0,
              top: 4.0,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(children: [
            // ispurchasing
            //     ? Container(
            //         width: MediaQuery.of(context).size.width * 0.7,
            //         height: MediaQuery.of(context).size.width * 0.9,
            //         child: Center(
            //             child: Column(
            //           children: [
            //             SizedBox(
            //               height: 30,
            //             ),
            //             const CircularProgressIndicator(
            //               color: AppColors.appblue,
            //             ),
            //             SizedBox(
            //               height: 10,
            //             ),
            //             Text(
            //               "Processing Transaction...",
            //               style: TextStyle(
            //                   color: AppColors.appblue, fontSize: 20.sp),
            //             ),
            //           ],
            //         )),
            //       )
            //     :

            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/images/wallet.png"),
                  IconButton(
                    icon: const Icon(
                      Icons.cancel_sharp,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Wallet Transactions",
                style: textstyle(30),
              ),

              SizedBox(height: 30),

              if (state != "requesting")
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        int currentAmount =
                            int.tryParse(amounttextcontroller.text) ?? 0;
                        if (currentAmount >= 100) {
                          amounttextcontroller.text =
                              (currentAmount - 100).toString();
                        }
                        due = int.tryParse(amounttextcontroller.text) ?? 0;
                        setState(() {});
                      },
                      icon: const Icon(Icons.remove, color: Colors.blue),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: amounttextcontroller,
                        onChanged: (value) {
                          print("Change text");
                          setState(() {
                            due = int.tryParse(amounttextcontroller.text) ?? 0;
                          });
                        },
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black87, fontSize: 25),
                        decoration: const InputDecoration(
                          labelText: 'Enter Amount to Transact',
                          labelStyle: TextStyle(color: Colors.black87),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          int currentAmount =
                              int.tryParse(amounttextcontroller.text) ?? 0;
                          amounttextcontroller.text =
                              (currentAmount + 100).toString();
                          due = int.tryParse(amounttextcontroller.text) ?? 0;
                        });
                      },
                      icon: const Icon(Icons.add, color: Colors.blue),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              if (state != "requesting")
                const Text(
                  'Quick selection',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                  ),
                ),

              const SizedBox(height: 10),
              if (state != "requesting")
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildQuickAmountButton(500),
                      _buildQuickAmountButton(1000),
                      _buildQuickAmountButton(2000),
                      _buildQuickAmountButton(5000),
                    ],
                  ),
                ),
              const SizedBox(height: 20),

              if (selectedwallet != null && !widget.isdeducttransaction)
                Column(
                  children: [
                    const Text(
                      'Select Reload Option:',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (false)
                      ListTile(
                        title: Text(
                          'Credit Card',
                          style: textstyle(25),
                        ),
                        leading: Radio<PaymentOption>(
                          value: PaymentOption.card,
                          groupValue: selectedOption,
                          onChanged: (PaymentOption? value) {
                            setState(() {
                              selectedOption = value;
                            });
                          },
                        ),
                      ),
                    ListTile(
                      title: Text(
                        'Mpesa',
                        style: textstyle(25),
                      ),
                      leading: Radio<PaymentOption>(
                        value: PaymentOption.mpesa,
                        groupValue: selectedOption,
                        onChanged: (PaymentOption? value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                      ),
                    ),
                    if (selectedOption == PaymentOption.mpesa)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 16),
                          // const Text(
                          //   'Enter Phone Number:',
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontSize: 16,
                          //   ),
                          // ),
                          const SizedBox(height: 8),
                          TextFormField(
                            readOnly: state != "canrequest",
                            onChanged: (value) {
                              setState(() {
                                phoneNumber = value;
                              });
                            },
                            keyboardType: TextInputType.phone,
                            style: textstyle(24, col: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle:
                                  const TextStyle(color: Colors.black87),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black87),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black87),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 20.0, end: 10.0),
                                child: ConstrainedBox(
                                  constraints:
                                      BoxConstraints.tight(const Size(24, 24)),
                                  child: SvgPicture.asset(
                                      'assets/images/kenya.svg'),
                                ),
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    // color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/mpesa.svg',
                                    height: 70,
                                    width: 70,
                                  )),
                              const Text(
                                'Top up Amount: ',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black87),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                due.toStringAsFixed(2),
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    if (selectedOption == PaymentOption.mpesa &&
                        state == "canrequest")
                      myButtons(context, "Make Request", Icons.payments_sharp,
                          () async {
                        if (!_validmpesa(phoneNumber)) return;

                        if (due < 10) {
                          return;
                        }

                        setState(() {
                          state = "requesting";
                          statedesc = "Requesting. Please wait...";
                        });
                        printLog("set requesting");

                        await comms_repo
                            .paymentRequest(due, phoneNumber, selectedwallet!)
                            .then((valuemp) async {
                          if (valuemp!.bool_code) {
                            mpesarequest = valuemp;
                            showalert(true, context, "Success",
                                "Request sent. wait for Pin input request");
                            setState(() {
                              state = "requesting";
                              statedesc =
                                  "Request sent. wait for Pin input request";
                            });

                            int retries = 0;
                            printLog("Get status for ${mpesarequest.trx_id}");

                            while (retries < 10) {
                              await comms_repo.MpesaPaymentStatus(
                                      valuemp.trx_id)
                                  .then((value) async {
                                printLog("Get status $value");

                                if (value["Payment_Status"] == "success") {
                                  setState(() {
                                    statedesc = "Confirmed";
                                  });

                                  showalert(true, context, "Success",
                                      "Mpesa Payment Confirmed\n");

                                  Navigator.pop(context, {
                                    "canTopUp": true,
                                    "paymode": "MPESA",
                                    // "ref": value["mpesa_code"],
                                    "mpesa_phone": phoneNumber,
                                    "amount": due
                                  });

                                  return;
                                } else {
                                  printLog("Get status. check again $value");
                                  if (value["Payment_Status"] == "failed") {
                                    showalert(false, context, "Oops",
                                        "Request Failed\nUnable to Contact Subscriber");

                                    retries = 11;
                                    setState(() {
                                      state = "canrequest";
                                      statedesc =
                                          "Unable to Contact Subscriber";
                                    });
                                    return;
                                  }
                                  if (value["Payment_Status"] == "cancelled") {
                                    showalert(false, context, "Oops",
                                        "Request cancelled\nSubscriber Cancelled");

                                    retries = 11;
                                    setState(() {
                                      state = "canrequest";
                                      statedesc = "Subscriber Cancelled";
                                    });
                                    return;
                                  }
                                }
                                retries += 1;
                              });
                              await Future.delayed(const Duration(seconds: 3));
                            }
                            showalert(false, context, "Oops!",
                                "Unable to confirm Mpesa Payment");

                            setState(() {
                              state = "timedout";
                              statedesc = "Unable to confirm payment";
                            });

                            return;
                            //    Navigator.pop(context);
                          } else {
                            showalert(
                                false, context, "Oops!", "Request Timed Out");

                            setState(() {
                              state = "canrequest";
                              statedesc = "Request Timed Out";
                            });
                          }
                        });
                      }),
                    const SizedBox(height: 16),
                    if (selectedOption == PaymentOption.mpesa &&
                        state == "requesting")
                      const SpinKitThreeInOut(
                        color: AppColors.indexcolor,
                        size: 50.0,
                      ),
                    if (selectedOption == PaymentOption.mpesa &&
                        state == "timedout")
                      myButtons(
                        context,
                        "Check Status again",
                        Icons.check,
                        () async {
                          await comms_repo.MpesaPaymentStatus(
                                  mpesarequest.trx_id)
                              .then((value) async {
                            printLog("Get recheck status $value");

                            if (value["Payment_Status"] == "success") {
                              setState(() {
                                statedesc = "Confirmed";
                              });

                              showalert(true, context, "Success",
                                  "Mpesa Payment Confirmed\n");

                              Navigator.pop(context, {
                                "canTopUp": true,
                                "paymode": "MPESA",
                                // "ref": value["mpesa_code"],
                                "mpesa_phone": phoneNumber,
                                "amount": due
                              });
                              return;
                            } else if (value["Payment_Status"] == "failed") {
                              showalert(false, context, "Oops",
                                  "Request Failed\nUnable to Contact Subscriber");
                              setState(() {
                                statedesc = "Unable to Contact Subscriber";
                                state = "canrequest";
                              });
                            } else {
                              showalert(false, context, "Oops",
                                  "Request Failed\nUnable to Process");
                              setState(() {
                                statedesc = "Unable to Process";
                                state = "canrequest";
                              });
                            }
                          });
                        },
                      ),
                    if (selectedOption == PaymentOption.mpesa &&
                        state == "timedout")
                      SizedBox(
                        height: 10,
                      ),
                    Center(
                      child: Text(
                        statedesc,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    if (selectedOption != PaymentOption.mpesa)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          topupnow
                              ? processingWidget(
                                  "Processing", 30, AppColors.indexcolor)
                              : myButtons(
                                  context,
                                  "Top Up ",
                                  Icons.credit_score_rounded,
                                  () {
                                    // Implement Cash payment logic
                                    print("By card. send command");

                                    // setState(() {
                                    //   topupnow = true;
                                    // });

                                    // lets exit.go back to owner to top up

                                    Navigator.pop(context, {
                                      "canTopUp": true,
                                      "paymode": "CASH",
                                      "ref": "",
                                      "mpesa_phone": "",
                                      "amount": due
                                    });
                                  },
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          myButtons(context, "Cancel", Icons.cancel,
                              () => Navigator.of(context).pop(Null)),
                        ],
                      ),
                  ],
                ),

              if (selectedwallet == null)
                inputField(desccontroller, "Transaction Description",
                    lines: 3, height: 60.0),
              SizedBox(
                height: 10,
              ),

              if (selectedwallet == null)
                (loadingwallets)
                    ? Center(
                        child: const CircularProgressIndicator(
                          color: AppColors.appblue,
                        ),
                      )
                    : myButtons(context, "Load Wallets", Icons.send, () {
                        printLog("ispurchasing $ispurchasing");
                        if (desccontroller.text == "") {
                          showalert(
                              false, context, "Invalid", "Enter a descriptin");
                          return;
                        }
                        if (amounttextcontroller.text == "") {
                          showalert(false, context, "Invalid",
                              "Enter a valid amount");
                          return;
                        }
                        if (int.parse(amounttextcontroller.text) < 50) {
                          showalert(false, context, "Invalid",
                              "Enter an amount of at least 50");
                          return;
                        }
                        print('continue');
                        // setState(() {
                        //   cantransact = true;
                        // });
                        loadWallets();
                      }),

              SizedBox(
                height: 20,
              ),
              // if (false)

              Container(
                  height: 330,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.red,
                  child: wallets.isEmpty
                      ? const Text("no wallets")
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //usercard(context),
                            Text(
                              wallets.length == 1
                                  ? "My Pocket"
                                  : 'My Pockets (${wallets.length})',
                              style: TextStyle(
                                fontSize: 30.0,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 280,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: wallets.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: PocketCardWidget(
                                      ontransactrequest: cardRequest,
                                      selected: selectedwallet ==
                                          wallets.elementAt(index),
                                      wallet: wallets.elementAt(index),
                                      istransaction: true,
                                      transactionamount: due,
                                      // Replace with actual card holder name
                                    ),
                                  );
                                },
                              ),
                            ),
                            //   SizedBox(height: 20),
                          ],
                        )

                  // Positioned(
                  //   bottom: 20,
                  //   right: 20,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       // Implement top-up wallet functionality
                  //     },
                  //     style: ElevatedButton
                  //         .styleFrom(
                  //       primary:
                  //           AppColors.appblue,
                  //     ),
                  //     child: Padding(
                  //       padding:
                  //           EdgeInsets.all(
                  //               10.0.w),
                  //       child: Text(
                  //         'Top Up Wallet',
                  //         style: TextStyle(
                  //           fontSize: 18,
                  //           color:
                  //               Colors.white,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  )
            ]),
          ]),
        ))));
  }

  Widget PayingAmountField() {
    // return BlocBuilder<RequestOtpBloc, OtpState>(builder: (context, state) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      child: TextFormField(
        style: const TextStyle(color: Colors.black),

        textInputAction: TextInputAction.done,
        focusNode: field_focus,
        controller: amounttextcontroller,
        enabled: (sendmpesa || ispurchasing) != true,

        onChanged: (value) {
          due = int.tryParse(amounttextcontroller.text) ?? 0;
          selectedwallet = null;
        },
        //  validator: (value) => v ? null : state.phoneNumber,
        textAlign: TextAlign.start,
        // ignore: prefer_const_constructors
        keyboardType: Platform.isIOS
            ? const TextInputType.numberWithOptions(signed: true, decimal: true)
            : TextInputType.number,
// This regex for only amount (price). you can create your own regex based on your requirement
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}'))
        ],
        decoration: InputDecoration(
          hintText: "Amount you wish to purchase *",
          filled: true,
          fillColor: Colors.grey.shade200,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFF5F2FE)),
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
    // });
  }

  Widget PhonenumberField() {
    // return BlocBuilder<RequestOtpBloc, OtpState>(builder: (context, state) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      child: TextFormField(
        style: const TextStyle(color: Colors.black),

        textInputAction: TextInputAction.done,
        // focusNode: field_focus,
        controller: mpesaNoTxtEditingController,
        enabled: (sendmpesa || ispurchasing) != true,

        onChanged: (value) => {},
        //  validator: (value) => v ? null : state.phoneNumber,
        textAlign: TextAlign.start,
        // ignore: prefer_const_constructors
        keyboardType: Platform.isIOS
            ? const TextInputType.numberWithOptions(signed: true, decimal: true)
            : TextInputType.number,
// This regex for only amount (price). you can create your own regex based on your requirement
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}'))
        ],
        decoration: InputDecoration(
          hintText: "Mpesa Phone Number ",
          filled: true,
          fillColor: Colors.grey.shade200,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFF5F2FE)),
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
    // });
  }

  bool _validmpesa(String mpesaNo) {
    if (mpesaNo.isEmpty) return false;
    final regExp = RegExp(
        r'/^(\+){0,1}(254){0,1}(70|71|72|79)(\d{7})|(254){0,1}(7|1)(\d{8})');
    return regExp.hasMatch(mpesaNo);
  }

  void loadWallets() async {
    if (selectedwallet != null) {
      printLog(
          "We already hae a wallet. dont load wallets. we know what we want");
      setState(() {
        loadingwallets = false;
      });
      return;
    }

    setState(() {
      loadingwallets = true;
    });

    var dewallet = await comms_repo.FetchWallets();
    if (dewallet != null) {
      wallets = dewallet;
    }
    setState(() {
      loadingwallets = false;
    });
  }

  cardRequest(Pocket _wallet, _request, _value) async {
    printLog("A Requested $_request value $_value on ${_wallet.pocketName}");
    selectedwallet = _wallet;

    if (_request == "SELECTED") {
      // setState(() {});
    } else if (_request == "TOP_UP") {
      await TransactFromWallet(context, selectedwallet, false);
    } else if (_request == "DEDUCT") {
      printLog("A Transact widget meter = .toJson()}");

      // if (widget.activemeter.pay_to_merchant_gate == "" ||
      //     widget.activemeter.pay_to_merchant_pocket == "") {
      showalert(false, context, "Sorry", "The Account Is not Linked!");
      return;
    }

    // all deduct to earthview
    // showProcessingDialog(context, widget.activemeter, null);
    await comms_repo
        .payByIndX(selectedwallet!, null, due, desccontroller.text)
        .then((value) {
      closeProcessingDialog(context);

      printLog(" rsp $value");
      if (value != null) {
        printLog("msg ${value["message"]} ");
        if (value["status"]) {
          Navigator.pop(context, value);

          // now shoe token info
          showalert(true, context, "Success", "Payment Made successfully.");

          // showProcessingDialog(
          //     context,
          //     widget.activemeter,
          //     TokenModel(
          //         token: value["token"],
          //         amount: double.parse(value["Total_paid"].toString()),
          //         price_unit: value["Price_unit"]));
        } else {
          showalert(false, context, "Ooops!", value["message"]);
        }
      }
    });

    // setState(() {
    //   ispurchasing = true;
    // });

    // await Future.delayed(const Duration(seconds: 4));
    // printLog("Successfully dedcuted from pocket");

    // setState(() {
    //   ispurchasing = false;
    // });
  }
}

Widget _buildQuickAmountButton(int amount) {
  bool isSelected = false; //due == amount;
  return Container(
    padding: EdgeInsets.only(right: 10),
    width: 120,
    child: ElevatedButton(
      onPressed: () {
        // setState(() {
        //   due = amount;
        //   amounttextcontroller.text =
        //       amount.toStringAsFixed(0); // Clear the amount input field
        // });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey,
      ),
      child: Text(
        '\KES $amount',
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 16,
        ),
      ),
    ),
  );
}
