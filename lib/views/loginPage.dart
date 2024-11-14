import 'package:application/views/signUpPage.dart';
import 'package:application/views/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../Models/AccountTypes.dart';
import '../Models/user.dart';
import '../comms/credentials.dart';
import '../utils/utils.dart';
import '../utils/widgets.dart';
import 'widgets/globals.dart';
import 'widgets/drivers/homepage/DriverHomeScreen.dart';
class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
   TextEditingController uname = TextEditingController();
   TextEditingController upass = TextEditingController();
  bool loginin = false;
  String title = "";

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
uname = TextEditingController(text: "johndoe@example.com");
upass = TextEditingController(text: "dummyPassword123");

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
                              myController: uname,
                              hintText: "Email",
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
                              myController: upass,
                              hintText: "Password",
                              isPassword: true,
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
                                  "Log in",
                                  () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        loginin = true;
                                      });
                                      final Map<String, dynamic> body = {
                                        "email": uname.text.trim(),
                                        "password": upass.text.trim(),
                                        "role": current_role,
                                      };

                                      printLog("Login $body");

                                      await comms_repo.QueryAPIpost(
                                              "auth/login", body)
                                          .then((value) {
                                        printLog("User info $value");
                                        setState(() {
                                          loginin = false;
                                        });

                                        if (value["success"] ?? false) {
                                          current_user =
                                              userModel.fromMap(value);
                                          current_user.access_token =
                                              value["accessToken"];
                                          showalert(
                                            true,
                                            context,
                                            "Success",
                                            value["message"] ?? "Welcome",
                                          );

                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (ctx) => getHome(),
                                            ),
                                          );
                                        } else {
                                          showalert(
                                            false,
                                            context,
                                            "Failed",
                                            value["message"] ??
                                                "Unable to Login",
                                          );
                                        }
                                      });
                                    }
                                  },
                                ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: Colors.white70),
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
