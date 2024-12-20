import 'package:application/Authentication/pro.dart';
import 'package:application/Authentication/signUpPage.dart';
import 'package:application/Models/TrucksModel.dart';
import 'package:application/Models/user.dart';
import 'package:application/comms/Req.dart';
import 'package:application/comms/credentials.dart';
import 'package:application/utils/utils.dart';
import 'package:application/utils/widgets.dart';
import 'package:application/views/widgets/Fps/drivers/homepage/DriverHomePage.dart';
import 'package:application/views/widgets/globals.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';

class DriverRegister extends StatefulWidget {
  @override
  State<DriverRegister> createState() => _DriverRegisterState();
}

class _DriverRegisterState extends State<DriverRegister> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController truckLicencePlateControler = TextEditingController();
  Trucksmodel? truck;
  String? licencePlate;

  bool loginin = false;
  String title = "";
  late Future<List<Trucksmodel>> trucks;
  Trucksmodel? selectedTruck; // Add this to s

  Future<List<Trucksmodel>> getTrucks() async {
    return await AppRequest.fetchTrucks();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    trucks = getTrucks();
  }

  void _handleDriverLogin() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> body = {
        "phone": phoneController.text.trim(),
        "truckLicencePlate": truckLicencePlateControler.text.trim(),
        "role": "DR"
      };
      await comms_repo.QueryAPIpost("auth/login", body, context).then((value) {
        print("###########################$value");
        if (value["success"]) {
          current_user = userModel.fromMap(value["user"]);
          current_user.access_token = value["accessToken"];

          print("#####${current_user.id}");
          print("#####${current_user.truckLicencePlate}");
          print("#####${current_user.access_token}");

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DriverHomepage()));

          CherryToast.success(
            title: Text(
              "Login Successful",
              style: TextStyle(color: Colors.black),
            ),
            toastPosition: Position.top,
            animationDuration: Duration(milliseconds: 500),
            autoDismiss: true,
          ).show(context);
        } else {
          CherryToast.error(
            title: Text(
              "Login Failed",
              style: TextStyle(color: Colors.black),
            ),
            toastPosition: Position.bottom,
            animationDuration: Duration(milliseconds: 500),
            autoDismiss: true,
          ).show(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    truckLicencePlateControler = TextEditingController(text: "kbc123w");
    phoneController = TextEditingController(text: "0769922989");

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isSmallScreen = constraints.maxWidth < 600;

          return Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF7E64D4),
                  Color(0xFF9DD6F8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: isSmallScreen ? screenHeight * 0.1 : 100),
                  SvgPicture.asset(
                    'assets/images/Logo.svg',
                    height: isSmallScreen ? 100 : 150,
                  ),
                  SizedBox(height: isSmallScreen ? 10 : 20),
                  Text(
                    'Your end-to-end water utility App',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 10),
                  Text(
                    'Buy. Manage. Monitor',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 30),
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      color: Colors.white70,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 24 : 30,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            width: screenWidth * 0.8,
                            child: CustomTextfield(
                              myController: phoneController,
                              hintText: "phone number",
                              isPassword: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field cannot be empty';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 12 : 20),
                          Container(
                            width: screenWidth * 0.8,
                            child: CustomTextfield(
                              myController: truckLicencePlateControler,
                              hintText: "truck licence plate ",
                              isPassword: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field cannot be empty';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                          loginin
                              ? const CircularProgressIndicator(
                                  color: Color.fromARGB(255, 51, 83, 142),
                                )
                              : CustomButton(
                                  context,
                                  "Login",
                                  () async {
                                    _handleDriverLogin();
                                  },
                                ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                        ],
                      ),
                    ),
                  ),

                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => SignupScreen(),
                  //       ),
                  //     );
                  //   },
                  //   child: RichText(
                  //     text: TextSpan(
                  //       children: [
                  //         TextSpan(
                  //           text: "Don't have an account? ",
                  //           style: TextStyle(color: Colors.white70),
                  //         ),
                  //         TextSpan(
                  //           text: 'Sign Up',
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: isSmallScreen ? 10 : 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
