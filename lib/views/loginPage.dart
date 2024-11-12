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
import 'widgets/homepage/HomeScreen.dart';
// import 'package:qiu/utils/utils.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _issueDescriptionController =
      TextEditingController();
  final TextEditingController uname = TextEditingController();
  final TextEditingController upass = TextEditingController();
  String? _issueType;
  DateTime? _selectedDate;
  bool loginin = false;
  String title = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              SvgPicture.asset(
                'assets/images/Logo.svg',
                height: 150,
              ),
              SizedBox(height: 20),
              Text(
                'Your end to end water utility App',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Buy. Manage. Monitor',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              Form(
                key: _formKey,
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
                      child: Column(
                        children: <Widget>[
                          Text(
                            title,
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: CustomTextfield(
                              myController: uname,
                              hintText: " Email",
                              isPassword: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field cannot be empty';
                                }

                                return null;
                              },
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: CustomTextfield(
                              myController: upass,
                              hintText: " Password",
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field cannot be empty';
                                }

                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
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
                                        "role": current_role // my saved tole
                                      };

                                      printLog("Login $body");

                                      await comms_repo.QueryAPIpost(
                                              "auth/login", body)
                                          .then((value) {
                                        printLog("USer ifo $value");
                                        setState(() {
                                          loginin = true;
                                        });

                                        if (value["success"] ?? false) {
                                          // got o login
                                          current_user =
                                              userModel.fromMap(value);

                                          showalert(true, context, "Success",
                                              value["message"] ?? "Welcome");

                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (ctx) => HomeScreen(),
                                            ),
                                          );
                                        } else {
                                          showalert(
                                              false,
                                              context,
                                              "Failed",
                                              value["message"] ??
                                                  "Unable to Login");
                                        }
                                      });
                                    }
                                  },
                                ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                )),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  // Navigator.pushNamed(context, '/signup');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupScreen()));
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
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
