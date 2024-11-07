import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Models/walletmodel.dart';
import '../../comms/credentials.dart';
import '../../mpesa_number.dart';
import '../../mpesa_numbers.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import '../../utils/widgets.dart';
import 'components/withdrawpocketwidget.dart';

Future<dynamic> WithdrawFromWallet(BuildContext context, Pocket? walle) async {
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
                  child: WalletWithdrawal(wallet: walle)),
            ],
          )));
}

class WalletWithdrawal extends StatefulWidget {
  const WalletWithdrawal({
    Key? key,
    this.wallet,
  }) : super(key: key);

  final Pocket? wallet;
  @override
  State<WalletWithdrawal> createState() => _WalletWithdrawalState();
}

class _WalletWithdrawalState extends State<WalletWithdrawal> {
  FocusNode field_focus = FocusNode();
  late MpesaNumbers mpesaNumbers;
  late TextEditingController mpesaNoTxtEditingController,
      desccontroller,
      amounttextcontroller;
  bool sendmpesa = false;
  bool iswithdrawing = false;
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

    mpesaNumbers =
        MpesaNumbers(message: "mess", numberOfPhoneNumbers: 1, numbers: [
      Numbers(
          id: 1,
          phoneNumber: rawPhone,
          isDefault: true,
          createdOn: DateTime.now().toString())
    ]);

    amounttextcontroller.text =
        widget.wallet!.withdrawableAmount.toInt().toString();
    due = widget.wallet!.withdrawableAmount.toInt();
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
            /*  ispurchasing
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.9,
                    child: Center(
                        child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        const CircularProgressIndicator(
                          color: AppColors.appblue,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Processing Transaction...",
                          style: TextStyle(
                              color: AppColors.appblue, fontSize: 20.sp),
                        ),
                      ],
                    )),
                  )
                :*/

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
              const SizedBox(
                height: 20,
              ),
              Text(
                "Withdraw from Wallet",
                style: textstyle(30),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 260,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: PocketWithdrwaCardWidget(
                    wallet: widget.wallet!,

                    // Replace with actual card holder name
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _mpesaNumbersSelection(context),
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
                        labelText: 'Amount to Withdraw',
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
                        if (currentAmount + 100 >
                            widget.wallet!.accountBalance) {
                          amounttextcontroller.text =
                              widget.wallet!.accountBalance.toString();
                          return;
                        }

                        amounttextcontroller.text =
                            (currentAmount + 100).toString();
                        due = int.tryParse(amounttextcontroller.text) ?? 0;
                      });
                    },
                    icon: const Icon(Icons.add, color: Colors.blue),
                  ),
                ],
              ),
              // const SizedBox(height: 20),
              // const Text(
              //   'Quick selection',
              //   style: TextStyle(
              //     color: Colors.black87,
              //     fontSize: 18,
              //   ),
              // ),
              const SizedBox(height: 10),
              if (widget.wallet!.accountBalance >= 500)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildQuickAmountButton(500),
                      if (widget.wallet!.accountBalance >= 1000)
                        _buildQuickAmountButton(1000),
                      if (widget.wallet!.accountBalance >= 2000)
                        _buildQuickAmountButton(2000),
                      if (widget.wallet!.accountBalance >= 5000)
                        _buildQuickAmountButton(5000),
                      if (widget.wallet!.accountBalance >= 10000)
                        _buildQuickAmountButton(10000),
                      if (widget.wallet!.accountBalance >= 20000)
                        _buildQuickAmountButton(20000),
                    ],
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
              iswithdrawing
                  ? processingWidget("Requesting...", 30, AppColors.indexcolor)
                  : myButtons(context, "Withdraw", Icons.download, () {
                      if (due < 5) {
                        showalert(false, context, "Invalid",
                            "Invalid amount entered");
                        return;
                      }

                      if (due > widget.wallet!.withdrawableAmount) {
                        showalert(false, context, "Oops", "Insufficient Funds");
                        return;
                      }

                      setState(() {
                        iswithdrawing = true;
                      });

                      comms_repo.withdraw(widget.wallet!, due).then((value) {
                        printLog("Withdrwa Respoosne $value");
                        setState(() {
                          iswithdrawing = false;
                        });

                        if (value["rsp"]) {
                          showalert(true, context, "Success", value["msg"]);
                          Navigator.pop(context, true);
                        } else {
                          showalert(false, context, "Oops", value["msg"]);
                        }
                      });
                    })
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
        enabled: (iswithdrawing) != true,

        onChanged: (value) =>
            {due = int.tryParse(amounttextcontroller.text) ?? 0},
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
        enabled: (iswithdrawing) != true,

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
        loadingwallets = true;
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
    setState(() {});
  }
  /*

  cardRequest(Pocket _wallet, _request, _value) async {
    printLog("Requested $_request value $_value on ${_wallet.pocketName}");
    selectedwallet = _wallet;

    if (_request == "SELECTED") {
      // setState(() {});
    } else if (_request == "TOP_UP") {
      // await TransactFromWallet(context, widget.activemeter, selectedwallet);
    } else if (_request == "DEDUCT") {
      // all deduct to earthview
      showProcessingDialog(context, widget.activemeter, null);
      await comms_repo
          .payByIndX(selectedwallet!, due, desccontroller.text)
          .then((value) {
        closeProcessingDialog(context);

        printLog(" rsp $value");
        if (value != null) {
          printLog("msg ${value["message"]} ");
          if (value["status"]) {
            Navigator.pop(context, value);

            // now shoe token info
            CustomToast.successToast("Success", "Payment Made successfully.");
            showProcessingDialog(
                context,
                widget.activemeter,
                TokenModel(
                    token: value["token"],
                    amount: double.parse(value["Total_paid"].toString()),
                    price_unit: value["Price_unit"]));
          } else {
            CustomToast.errorToast("Ooops!", value["message"]);
          }
        }
      });

  
    }
  }

  */

  Widget _buildQuickAmountButton(int amount) {
    bool isSelected = due == amount;
    return Container(
      padding: EdgeInsets.only(right: 10),
      width: 120,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            due = amount;
            amounttextcontroller.text =
                amount.toStringAsFixed(0); // Clear the amount input field
          });
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

  Widget _mpesaNumbersSelection(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 80,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'M-PESA NUMBER',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      color: const Color(0xff111111),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: ListView.separated(
                  // shrinkWrap: true,
                  itemCount: mpesaNumbers!.numberOfPhoneNumbers!,
                  itemBuilder: (context, index) {
                    return MpesaNumber(
                        number: mpesaNumbers.numbers![index]!.phoneNumber!
                            .toString(),
                        index: index,
                        selectedIndex: 0,
                        onIndexChanged: () {
                          setState(() {
                            // selectedIndex = index;
                          });
                        });
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
