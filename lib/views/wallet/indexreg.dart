import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../utils/securestorage.dart';
import '../../Models/walletmodel.dart';
import '../../comms/credentials.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import '../../utils/widgets.dart';

Future<dynamic> IndxRegistration(
  BuildContext context,
) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30))),
    builder: (context) {
      return IndxReg();
    },
  );
}

class IndxReg extends StatefulWidget {
  const IndxReg({
    // required this.title,
    // required this.onPressed,
    Key? key,
  }) : super(key: key);

  // final String title;
  // final Function(int index, dynamic data) onPressed;

  @override
  State<IndxReg> createState() => IndxRegState();
}

class IndxRegState extends State<IndxReg> {
  bool registering = false;
  bool processing = false;
  bool hasaccount = true;
  String statustring = "";
  TextEditingController uname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController phon = TextEditingController();
  TextEditingController pass2 = TextEditingController();
  TextEditingController wallet = TextEditingController();
  //
  @override
  void initState() {
    super.initState();

    uname.text = currentIndexUser.userName == ""
        ? current_user.user_name
        : currentIndexUser.userName!;
    pass.text = currentIndexUser.userPass == ""
        ? current_user.password
        : currentIndexUser.userPass!;
    email.text = currentIndexUser.userEmail == ""
        ? rawemail
        : currentIndexUser.userEmail!;

    phon.text = currentIndexUser.userPhone == ""
        ? rawPhone
        : currentIndexUser.userPhone!;

    printLog(
        "rawemail $rawemail rawphone $rawPhone  cemail ${current_user.email} cphoen ${current_user.phone_number}");

    wallet.text = "Smart Utility";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return hasaccount
        ? FractionallySizedBox(
            heightFactor: 0.95,
            widthFactor: 0.97,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SingleChildScrollView(child: loginscreen()),
              ),
            ),
          )
        : Scaffold(
            body: FractionallySizedBox(
              heightFactor: 0.95,
              widthFactor: 0.97,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SingleChildScrollView(child: signupscreen()),
                ),
              ),
            ),
          );
  }

  Color _getSequenceColor(int index) {
    int val = index % 3;

    if (val == 2) {
      return Colors.lightBlue;
    } else if (val == 1) {
      return Colors.amber;
    } else {
      return Colors.redAccent;
    }
  }

  Widget PhonenumberField() {
    // return BlocBuilder<RequestOtpBloc, OtpState>(builder: (context, state) {

    return TextFormField(
      readOnly: processing,
      onChanged: (value) {
        setState(() {
          phon.text = value;
        });
      },
      keyboardType: TextInputType.phone,
      style: const TextStyle(fontSize: 24, color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Phone Number',
        labelStyle: const TextStyle(color: Colors.black87),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black87),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black87),
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(start: 20.0, end: 10.0),
          child: ConstrainedBox(
            constraints: BoxConstraints.tight(const Size(24, 24)),
            child: SvgPicture.asset('assets/images/kenya.svg'),
          ),
        ),
      ),
    );
//     return ClipRRect(
//       borderRadius: BorderRadius.all(Radius.circular(10.0.w)),
//       child: TextFormField(
//         style: const TextStyle(color: Colors.black),

//         textInputAction: TextInputAction.done,
//         // focusNode: field_focus,
//         controller: phon,
//         enabled: (registering) != true,

//         onChanged: (value) => {},
//         //  validator: (value) => v ? null : state.phoneNumber,
//         textAlign: TextAlign.start,
//         // ignore: prefer_const_constructors
//         keyboardType: Platform.isIOS
//             ? const TextInputType.numberWithOptions(signed: true, decimal: true)
//             : TextInputType.number,
// // This regex for only amount (price). you can create your own regex based on your requirement
//         inputFormatters: [
//           FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}'))
//         ],
//         decoration: InputDecoration(
//           hintText: "Mpesa Phone Number ",
//           filled: true,
//           fillColor: Colors.grey.shade200,
//           focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Color(0xFFF5F2FE)),
//             borderRadius: BorderRadius.circular(4.w),
//           ),
//           enabledBorder: const UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           floatingLabelBehavior: FloatingLabelBehavior.always,
//         ),
//       ),
//     );
    // });
  }

  loginscreen() => Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10 / 2),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/indxlogo.png",
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
            const SizedBox(height: 50),
            Text(
              "Welcome to Indx Pay",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            inputField(email, "Email address",
                height: 60.0, width: MediaQuery.of(context).size.width * 0.7),
            inputField(pass, "Password",
                height: 60.0,
                ispassword: true,
                width: MediaQuery.of(context).size.width * 0.7),
            const SizedBox(height: 50),
            _accountoption(),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Forgot Password? ",
                  style: TextStyle(color: AppColors.indexcolor),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "Reset Password",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            processing
                ? processingWidget("Processing")
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      myButtons(context, "Cancel", Icons.verified_user,
                          () async {
                        Navigator.pop(context);
                      },
                          bgcolor: AppColors.indexcolororange,
                          width: MediaQuery.of(context).size.width * 0.4),
                      myButtons(context, "Log In", Icons.verified_user,
                          () async {
                        if (!validateEmail(email.text)) {
                          showalert(
                              false, context, "Oops!", "Invalid email address");
                          return;
                        }

                        if (pass.text.trim() == "") {
                          showalert(
                              false, context, "Oops!", "Inpot your Password");
                          return;
                        }

                        setState(() {
                          processing = true;
                        });

                        currentIndexUser.userName = uname.text;
                        currentIndexUser.userEmail = email.text;
                        currentIndexUser.userPass = pass.text;

                        await comms_repo.walletsLogin().then((value) async {
                          printLog("Wsallet login Response $value");

                          setState(() {
                            processing = false;
                          });
                          if (value != null) {
                            if (value != null) {
                              if (value["rsp"]) {
                                // save dis
                                printLog("suvccess. Fetch wallets now");

                                PocketsResponse? pocketsResponse =
                                    PocketsResponse.fromJson(value);

                                currentIndexUser.wallets =
                                    pocketsResponse!.pockets;

                                if (currentIndexUser.wallets!.isEmpty) {
                                  // printLog("create default wallet");
                                  // setState(() {
                                  //   statustring = "Creating Pocket";
                                  // });
                                  // await comms.createPocket(wallet.text)
                                  showalert(false, context, "Sorry",
                                      "Unable to fetch created Wallets");
                                } else {
                                  currentIndexUser.active = true;
                                  await SecureStorageService.writeValue(
                                      "index_user",
                                      jsonEncode(currentIndexUser.toJsonMap()));

                                  printLog("not empty. we have wallets. yaay");
                                  // Get.offAndToNamed(AppRoutes.Wallets);
                                }
                              } else {
                                showalert(
                                    false, context, "Sorry", value["msg"]);
                              }
                            }
                          }
                        });

                        setState(() {
                          processing = false;
                        });
                      },
                          width: MediaQuery.of(context).size.width * 0.4,
                          bgcolor: AppColors.indexcolor),
                    ],
                  ),
            Text(
              statustring,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );

  signupscreen() => Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10 / 2),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/indxlogo.png",
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
            const SizedBox(height: 50),
            Text(
              "Welcome to Indx Pay.",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            inputField(uname, "User Name",
                height: 60.0, width: MediaQuery.of(context).size.width * 0.8),
            inputField(email, "Email address",
                height: 60.0, width: MediaQuery.of(context).size.width * 0.8),
            const SizedBox(height: 20),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: PhonenumberField()),
            inputField(pass, "Preffered Password",
                height: 60.0,
                ispassword: true,
                width: MediaQuery.of(context).size.width * 0.8),
            inputField(pass2, "Confirm Password",
                height: 60.0,
                ispassword: true,
                width: MediaQuery.of(context).size.width * 0.8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/images/indxwallet.png",
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                ),
                inputField(wallet, "Preffered Wallet Name",
                    height: 60.0, width: 200)
              ],
            ),
            const SizedBox(height: 50),
            _accountoption(),
            SizedBox(
              height: 20,
            ),
            processing
                ? processingWidget(
                    "Registering",
                  )
                // fontcolor: AppColors.indexcolor)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      myButtons(context, "Cancel", Icons.verified_user,
                          () async {
                        Navigator.pop(context);
                      },
                          bgcolor: AppColors.indexcolororange,
                          width: MediaQuery.of(context).size.width * 0.4),
                      myButtons(context, "Register", Icons.verified_user,
                          () async {
                        if (!validmpesa(phon.text)) {
                          showalert(
                              false, context, "Oops!", "Invalid Phone Number");
                          return;
                        }
                        if (!validateEmail(email.text)) {
                          showalert(
                              false, context, "Oops!", "Invalid email address");
                          return;
                        }

                        if (pass.text.trim() == "" || pass.text != pass2.text) {
                          showalert(
                              false, context, "Oops!", "Confirm your Password");
                          return;
                        }

                        if (wallet.text.trim().length < 3) {
                          showalert(
                              false, context, "Oops!", "Enter the Wallet Name");
                          return;
                        }

                        setState(() {
                          processing = true;
                        });

                        currentIndexUser.userName = uname.text;
                        currentIndexUser.userPass = pass.text;
                        currentIndexUser.userPhone = phon.text;
                        currentIndexUser.userEmail = email.text;

                        currentIndexUser.active = false;

                        await comms_repo.walletsRegister().then((value) async {
                          printLog("Wallet login Response $value");

                          if (value != null) {
                            if (value["rsp"]) {
                              printLog("suvccess");
                              if (currentIndexUser.wallets!.isEmpty) {
                                printLog("create default wallet");
                                setState(() {
                                  statustring = "Creating Pocket";
                                });
                                await comms_repo.createPocket(wallet.text).then(
                                  (xx) async {
                                    printLog("Create Pocket MSG $xx");
                                    if (xx) {
                                      currentIndexUser.active = true;
                                      await SecureStorageService.writeValue(
                                          "index_user",
                                          jsonEncode(
                                              currentIndexUser.toJsonMap()));
                                      // Get.offAndToNamed(AppRoutes.Wallets);
                                    }
                                  },
                                );
                              } else {
                                printLog("not empty. we have a wallet");
                                currentIndexUser.active = true;
                                await SecureStorageService.writeValue(
                                    "index_user",
                                    jsonEncode(currentIndexUser.toJsonMap()));
                                // Get.offAndToNamed(AppRoutes.Wallets);
                              }
                            } else {
                              showalert(false, context, "Sorry", value["msg"]);
                            }
                          }
                        });

                        setState(() {
                          processing = false;
                        });
                      },
                          width: MediaQuery.of(context).size.width * 0.4,
                          bgcolor: AppColors.indexcolor),
                    ],
                  ),
            SizedBox(
              height: 15,
            ),
            Text(
              statustring,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );

  _accountoption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          hasaccount
              ? "Don’t have an Account ? "
              : "Already have an Account ? ",
          style: const TextStyle(color: AppColors.indexcolor),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              hasaccount = !hasaccount;
            });
          },
          child: Text(
            hasaccount ? "Sign Up" : "Sign In",
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  // void loadWallets() async {
  //   if (selectedwallet != null) {
  //     printLog(
  //         "We already hae a wallet. dont load wallets. we know what we want");
  //     setState(() {
  //       loadingwallets = true;
  //     });
  //     return;
  //   }

  //   setState(() {
  //     loadingwallets = true;
  //   });

  //   var dewallet = await comms.FetchWallets();
  //   if (dewallet != null) {
  //     wallets = dewallet;
  //   }
  //   setState(() {});
  // }
}
