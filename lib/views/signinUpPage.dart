import '../Models/AccountTypes.dart';
import '../comms/Req.dart';
import '../utils/utils.dart';
import 'widgets/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'loginPage.dart';
import 'package:flutter/foundation.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Accountypes? accounttype;
  TextEditingController address = TextEditingController();
  TextEditingController source = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController quality = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String lat = "";
  String long = "";

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      address = TextEditingController(text: "123 Test Street, City");
      source = TextEditingController(text: "Local Market");
      name = TextEditingController(text: "John Doe");
      quality = TextEditingController(text: "Soft");
    }

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7E64D4),
              Color(0xFF9DD6F8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 70),
                  SvgPicture.asset(
                    'assets/images/Logo.svg',
                    height: 130,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your end to end water utility App',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Buy. Manage. Monitor',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (this.accounttype == null)
                    ...ListOptions()
                  else
                    ListSelection(),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> ListOptions() {
    return [
      const SizedBox(height: 20),
      buildWideButton(context, 'Water Service Provider', Colors.blue, () {
        setState(() {
          accounttype = Accountypes.WSP;
        });
      }, showarrow: false),
      buildWideButton(context, 'Fulfillment Partner', Colors.transparent, () {
        setState(() {
          accounttype = Accountypes.FP;
        });
      }, showarrow: false),
      buildWideButton(context, 'User/ Consumer', Colors.blue, () {
        setState(() {
          accounttype = Accountypes.USER;
        });
      }, showarrow: false),
      buildWideButton(context, 'Driver', Colors.transparent, () {
        setState(() {
          accounttype = Accountypes.DRIVER;
        });
      }, showarrow: false),
    ];
  }

  ListSelection() {
    if (accounttype == Accountypes.WSP) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextfield(
                  myController: name,
                  hintText: "Company Name",
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return "Please enter company name";
                    }
                    return null;
                  },
                ),
                CustomTextfield(
                  myController: quality,
                  hintText: "Water Quality",
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return "Please enter water quality";
                    }
                    return null;
                  },
                ),
                CustomTextfield(
                  myController: source,
                  hintText: "Water source",
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return "Please enter water source";
                    }
                    return null;
                  },
                ),
                CustomTextfield(
                  myController: address,
                  hintText: "Address",
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return "Please enter Address";
                    }
                    return null;
                  },
                ),
                Visibility(
                  visible: accounttype != null,
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          accounttype = null;
                        });
                      },
                      child: Text(
                        "Back",
                        style: GoogleFonts.poppins(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                CustomButton(context, "Sign Up", () async {
                  if (formKey.currentState!.validate()) {
                    printLog("sign up wsp");
                    final roleMap = {
                      Accountypes.WSP: 'WSP',
                      Accountypes.FP: 'FP',
                      Accountypes.SP: 'SP',
                      Accountypes.OP: 'OP',
                      Accountypes.DRIVER: 'Driver',
                      Accountypes.USER: 'USER',
                    };

// using   big on notation  (O(1) lookup)
                    String role = roleMap[accounttype] ?? 'OP';

                    final Map<String, dynamic> body = {
                      "role": role,
                      "lon": "36.86618503558242",
                      "lat": "-1.3299836851363906",
                      "physicalAddress": address.text.trim(),
                      "quality": quality.text.trim(),
                      "waterSource": source.text.trim(),
                      "companyName": name.text.trim()
                    };

                    printLog(body.toString());
                    await AppRequest.WSPSignup(context: context, data: body);
                  }
                })
              ],
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
