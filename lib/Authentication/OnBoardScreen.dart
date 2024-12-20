import 'package:application/views/widgets/Fps/RegisterFp.dart';
import 'package:application/views/widgets/Fps/drivers/RegisterDriver.dart';
import 'package:application/views/widgets/Fps/homepage/FPHomePage.dart';
import 'package:application/views/widgets/User/UserHomepage.dart';
import 'package:application/views/widgets/WSP/RegisterWSP.dart';
import 'package:application/views/widgets/WSP/homepage/WSPHomePage.dart';
import 'package:application/views/widgets/Fps/drivers/homepage/DriverHomePage.dart';
import 'package:application/views/widgets/globals.dart';

import '../Models/AccountTypes.dart';
import '../comms/Req.dart';
import '../utils/utils.dart';
import '../utils/widgets.dart';
import 'pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../comms/credentials.dart';
import 'loginPage.dart';
// import 'package:qiu/utils/utils.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  Accountypes? accounttype;
  _OnBoardScreenState({this.accounttype});

  TextEditingController address = TextEditingController();
  TextEditingController source = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController quality = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String lat = "";
  String long = "";
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    // accounttype = Accountypes.WSP;
    address = TextEditingController(text: "123 Test Street, City");
    source = TextEditingController(text: "Local Market");
    name = TextEditingController(text: "John Doe");
    quality = TextEditingController(text: "Soft");
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                  if (accounttype == null)
                    ...ListOptions()
                  else
                    ListSelection(),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      print("got sign in");
                      Navigator.pop(context);
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "< ",
                            style: TextStyle(color: Colors.black87),
                          ),
                          TextSpan(
                            text: '  Back to Consumer',
                            style: TextStyle(
                              color: Colors.black87,
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

  Widget buildSignInButton(
      BuildContext context, String text, Color color, Accountypes ttype,
      {bool showarrow = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: const BorderSide(
              color: Colors.white,
              width: 1.5,
            ),
          ),
        ),
        onPressed: () async {
          //  Navigator.pushNamed(context, '/login');
          // await LoginPage(Get.context!, ttype).then(
          //   (value) {
          //     printLog("Login page is back");
          //   },
          // );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: const TextStyle(fontSize: 18)),
            if (showarrow) const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }

  List<Widget> ListOptions() {
    return [
      const SizedBox(height: 20),
      buildWideButton(context, 'Water Service Provider', Colors.blue, () {
        // setState(() {
        //   accounttype = Accountypes.WSP;
        // });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterWsp()));
      }, showarrow: false),
      buildWideButton(context, 'Fulfillment Partner', Colors.transparent, () {
        // PersistentNavBarNavigator.pushNewScreen(
        //     withNavBar: true, context, screen: FPHomePage()); // Trucks());
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FPHomePage()));

        print("Shwo new home page");

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterFp()));
        // setState(() {
        //   accounttype = Accountypes.FP;
        // });
      }, showarrow: false),
      // buildWideButton(context, 'User/ Consumer', Colors.blue, () {
      //   setState(() {
      //     accounttype = Accountypes.USER;
      //   });
      // }, showarrow: false),
      buildWideButton(context, 'Driver', Colors.white38, () {
        setState(() {
          accounttype = Accountypes.DRIVER;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DriverRegister()));
      }, showarrow: false),

      // buildWideButton(context, 'User', Colors.transparent, () {
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => Userhomepage()));

      //   // Navigator.push(
      //   //     context, MaterialPageRoute(builder: (context) => FPHomePage()));
      //   // // setState(() {
      //   //   accounttype = Accountypes.FP;
      //   // });
      // }, showarrow: false),
    ];
  }

  ListSelection() {
    if (accounttype == Accountypes.WSP) {
      return Column(mainAxisSize: MainAxisSize.min, children: [
        Form(
            key: formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
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



                  printLog("Login $body");
                  await comms_repo.QueryAPIpost(
                          "users/register-service", body, context)
                      .then((value) async {
                    printLog("USer ifo $value");

                    setState(() {
                      saving = false;
                    });

                    if (value["success"] ?? false) {
                      printLog("Save current role");

                      current_role = "WSP";
                      await LocalStorage()
                          .setString("current_role", current_role);

                      showalert(true, context, "Success",
                          value["message"] ?? "COmpany Details Saved");

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (ctx) => getHome()),
                      );
                    } else {
                      showalert(false, context, "Failed",
                          value["message"] ?? "Unable to Login");
                    }
                  });
                }
              })
            ]))
      ]);
    }
    if (accounttype == Accountypes.FP) {
      return [];
    }
    return [];
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: 0.8,
        child: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 4.0,
                        right: 4.0,
                        top: 4.0,
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
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
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 100),
                                SvgPicture.asset(
                                  'assets/images/Logo.svg',
                                  height: 150,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Login',
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
                                const Text(
                                  'Sign In As',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OnBoardScreen()));
                                  },
                                  child: RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Don't have an account? ",
                                          style:
                                              TextStyle(color: Colors.white70),
                                        ),
                                        TextSpan(
                                          text: 'Sign Up',
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
                        ))))));
  }
}
