// import 'package:application/views/signUpPage.dart';
// import 'package:application/views/login.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';

// import '../Models/AccountTypes.dart';
// // import 'package:qiu/utils/utils.dart';

// class OnBoardScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFF7E64D4),
//               Color(0xFF9DD6F8),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: 100),
//               SvgPicture.asset(
//                 'assets/images/Logo.svg',
//                 height: 150,
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'Your end to end water utility App',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white70,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Buy. Manage. Monitor',
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 30),
//               Text(
//                 'Change Account to',
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.white70,
//                 ),
//               ),
//               SizedBox(height: 20),
//               buildSignInButton(context, 'Water Service Provider', Colors.blue,
//                   Accountypes.WSP),
//               buildSignInButton(context, 'Fulfillment Partner',
//                   Colors.transparent, Accountypes.FP),
//               // buildSignInButton(
//               //     context, 'User/ Consumer', Colors.blue, Accountypes.USER),
//               buildSignInButton(
//                   context, 'Driver', Colors.transparent, Accountypes.DRIVER),
//               Spacer(),

//               TextButton(
//                 onPressed: () {
//                   // Navigator.pushNamed(context, '/signup');
//                   // Navigator.push(context,
//                   //     MaterialPageRoute(builder: (context) => OnBoardScreen()));

//                   Navigator.pop(context);
//                 },
//                 child: RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: "Back to Consumer ",
//                         style: TextStyle(color: Colors.black87),
//                       ),
//                       // TextSpan(
//                       //   text: '',//           text: 'Sign Up',
//                       //   style: TextStyle(
//                       //     color: Colors.white,
//                       //     fontWeight: FontWeight.bold,
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildSignInButton(
//       BuildContext context, String text, Color color, Accountypes ttype) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             minimumSize: Size(double.infinity, 50),
//             backgroundColor: color,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(30.0),
//               side: BorderSide(
//                 color: Colors.white,
//                 width: 1.5,
//               ),
//             ),
//           ),
//           onPressed: () async {
//             // try {
//             //   await LoginPagePop(context, ttype);
//             // } catch (e) {
//             //   debugPrint("error loginpage $e");
//             // }
//           },
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Center(
//                   child: Text(
//                 text,
//                 style: TextStyle(fontSize: 18),
//               )),
//               Positioned(
//                 right: 0,
//                 child: Icon(Icons.arrow_forward),
//               )
//             ],
//           )
//           //  Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: [

//           //   ],
//           // ),
//           ),
//     );
//   }
// }

// class LoginScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FractionallySizedBox(
//         heightFactor: 0.8,
//         child: SafeArea(
//             child: SingleChildScrollView(
//                 child: Padding(
//                     padding: EdgeInsets.only(
//                         left: 4.0,
//                         right: 4.0,
//                         top: 4.0,
//                         bottom: MediaQuery.of(context).viewInsets.bottom),
//                     child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 Color(0xFF7E64D4),
//                                 Color(0xFF9DD6F8),
//                               ],
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                             ),
//                           ),
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 30.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SizedBox(height: 100),
//                                 SvgPicture.asset(
//                                   'assets/images/Logo.svg',
//                                   height: 150,
//                                 ),
//                                 SizedBox(height: 20),
//                                 Text(
//                                   'Login',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.white70,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 SizedBox(height: 10),
//                                 Text(
//                                   'Buy. Manage. Monitor',
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: 40),
//                                 Text(
//                                   'Sign In As',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     color: Colors.white70,
//                                   ),
//                                 ),
//                                 SizedBox(height: 20),
//                                 Spacer(),
//                                 TextButton(
//                                   onPressed: () {
//                                     //  Navigator.pushNamed(context, '/signup');
//                                     Navigator.pushReplacement(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 OnBoardScreen()));
//                                   },
//                                   child: RichText(
//                                     text: TextSpan(
//                                       children: [
//                                         TextSpan(
//                                           text: "Don't have an account? ",
//                                           style:
//                                               TextStyle(color: Colors.white70),
//                                         ),
//                                         TextSpan(
//                                           text: 'Sign Up',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 20),
//                               ],
//                             ),
//                           ),
//                         ))))));
//   }
// }

// // class OnBoardScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Sign Up'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(20.0),
// //         child: Column(
// //           children: [
// //             TextField(
// //               decoration: InputDecoration(labelText: 'Full Name'),
// //             ),
// //             TextField(
// //               decoration: InputDecoration(labelText: 'Email'),
// //             ),
// //             TextField(
// //               decoration: InputDecoration(labelText: 'Password'),
// //               obscureText: true,
// //             ),
// //             SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: () {
// //                 // Implement sign-up functionality here
// //               },
// //               child: Text('Sign Up'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

import 'package:application/Models/AccountTypes.dart';
import 'package:application/utils/utils.dart';
import 'package:application/utils/widgets.dart';
import 'package:application/views/login.dart';

import 'package:application/views/widgets/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../comms/credentials.dart';
import 'loginPage.dart';
import 'widgets/Fps/homepage/FPHomePage.dart';
import 'widgets/drivers/homepage/DriverHomeScreen.dart';
import 'widgets/trucks/Trucks.dart';
// import 'package:qiu/utils/utils.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  Accountypes? accounttype;
  TextEditingController address = TextEditingController();
  TextEditingController source = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController quality = TextEditingController();
  String lat = "";
  String long = "";
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                ...ListSelection(),
              const Spacer(),
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
        setState(() {
          accounttype = Accountypes.WSP;
        });
      }, showarrow: false),
      buildWideButton(context, 'Fulfillment Partner', Colors.transparent, () {
        // PersistentNavBarNavigator.pushNewScreen(
        //     withNavBar: true, context, screen: FPHomePage()); // Trucks());

        print("Shwo new home page");

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FPHomePage()));
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
      }, showarrow: false),
    ];
  }

  ListSelection() {
    if (accounttype == Accountypes.WSP) {
      return [
        CustomTextfield(
          myController: name,
          hintText: "Company Name",
        ),
        CustomTextfield(
          myController: quality,
          hintText: "Water Quality. Fresh or Salty",
        ),
        CustomTextfield(
          myController: source,
          hintText: "Water source. Borehole...",
        ),
        CustomTextfield(
          myController: address,
          hintText: "Address",
        ),
        //location pick
        CustomButton(context, "Register", () async {
          // printLog("sign up wsp");
          if (name.text.trim() == "") {
            showalert(false, context, "Missing", "Enter Company Name");
            return false;
          }
          if (quality.text.trim() == "") {
            showalert(false, context, "Missing", "Enter Water Quality");
            return false;
          }
          if (source.text.trim() == "") {
            showalert(false, context, "Missing", "Enter Source");
            return false;
          }
          if (address.text.trim() == "") {
            showalert(false, context, "Missing", "Enter Company Address");
            return false;
          }

          setState(() {
            saving = true;
          });

          final Map<String, dynamic> body = {
            "role": "WSP",
            "lon": long,
            "lat": lat,
            "physicalAddress": address.text,
            "quality": quality.text,
            "waterSource": source.text,
            "companyName": name.text
          };
          printLog("Login $body");
          await comms_repo.QueryAPIpost("users/register-service", body)
              .then((value) async {
            printLog("USer ifo $value");
            setState(() {
              saving = false;
            });

            if (value["success"] ?? false) {
              printLog("Save current role");

              current_role = "WSP";
              await LocalStorage().setString("current_role", current_role);

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
        })
      ];
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
