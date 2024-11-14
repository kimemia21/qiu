import 'package:application/Models/user.dart';
import 'package:application/comms/credentials.dart';
import 'package:application/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/utils.dart';
import 'widgets/drivers/homepage/DriverHomeScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _lastnameController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _phoneNumberController = TextEditingController();
  bool PS = false;
  bool CPS = false;
  bool logging_on = false;
  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Email validation regex
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  // Reusable function to create text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red.shade300, width: 2),
        ),
        errorStyle: TextStyle(color: Colors.red.shade300),
      ),
      style: TextStyle(color: Colors.white),
      obscureText: isPassword,
      validator: validator,
    );
  }

  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String label,
    required bool secure,
    required VoidCallback toggleSecure,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        suffixIcon: IconButton(
          onPressed: toggleSecure, // Call toggle function here
          icon: Icon(secure ? Icons.visibility_off : Icons.visibility),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red.shade300, width: 2),
        ),
        errorStyle: TextStyle(color: Colors.red.shade300),
      ),
      style: TextStyle(color: Colors.white),
      obscureText: secure,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
final _lastnameController = TextEditingController(text: "Doe");
final _nameController = TextEditingController(text: "John");
final _emailController = TextEditingController(text: "johndoe@example.com");
final _passwordController = TextEditingController(text: "dummyPassword123");
final _confirmPasswordController = TextEditingController(text: "dummyPassword123");
final _phoneNumberController = TextEditingController(text: "+254769922984");
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 4.0,
                right: 4.0,
                top: 4.0,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      SvgPicture.asset(
                        'assets/images/Logo.svg',
                        height: 150,
                      ),
                      // SizedBox(height: 20),
                      // Text(
                      //   'Sign Up',
                      //   style: TextStyle(
                      //     fontSize: 20,
                      //     color: Colors.white,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      SizedBox(height: 10),
                      Text(
                        'Join us to Buy, Manage, and Monitor',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _nameController,
                              label: 'First Name',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your First name';
                                }
                                if (value.length < 2) {
                                  return 'Name must be at least 2 characters long';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            _buildTextField(
                              controller: _lastnameController,
                              label: 'Last Name',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Last name';
                                }
                                if (value.length < 2) {
                                  return 'Name must be at least 2 characters long';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            _buildTextField(
                              controller: _emailController,
                              label: 'Email',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            _buildTextField(
                              controller: _phoneNumberController,
                              label: 'Phone Number',
                              isPassword: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            _buildPasswordTextField(
                              controller: _passwordController,
                              label: 'Password',
                              secure: PS,
                              toggleSecure: () {
                                setState(() {
                                  PS = !PS;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            _buildPasswordTextField(
                              controller: _confirmPasswordController,
                              label: 'Confirm Password',
                              secure: CPS,
                              toggleSecure: () {
                                setState(() {
                                  CPS = !CPS;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 30),
                            Container(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  setState(() {
                                    logging_on = true;
                                  });

                                  final Map<String, dynamic> body = {
                                    "fullname": _nameController.text.trim(),
                                    "email": _emailController.text.trim(),
                                    "phoneNumber":
                                        _phoneNumberController.text.trim(),
                                    "password": _passwordController.text.trim(),
                                  };

                                  var params = {
                                    "firstName": _nameController.text.trim(),
                                    "lastName": _lastnameController.text.trim(),
                                    "email": _emailController.text.trim(),
                                    "password": _passwordController.text.trim(),
                                    "phoneNo":
                                        _phoneNumberController.text.trim(),
                                    "deviceToken": firebaseToken
                                  };

                                  await comms_repo.QueryAPIpost(
                                          "auth/register", params)
                                      .then((value) async {
                                    printLog("USer ifo $value");
                                    setState(() {
                                      logging_on = false;
                                    });

                                    if (value["success"] ?? false) {
                                      // got o login

                                      current_role = "SC";
                                      await LocalStorage().setString(
                                          "current_role", current_role);

                                      current_user = userModel(
                                        access_token: value["accessToken"],
                                        active: true,
                                        email: _emailController.text.trim(),
                                        first_name: _nameController.text.trim(),
                                        last_name:
                                            _lastnameController.text.trim(),
                                        user_name: _nameController.text.trim(),
                                      );

                                      showalert(
                                          true,
                                          context,
                                          "Success",
                                          value["message"] ??
                                              "User Created Successfully");
                                      Navigator.pop(context);
                                    } else {
                                      showalert(
                                          false,
                                          context,
                                          "Failed",
                                          value["message"] ??
                                              "Unable to Register"); // token generated
                                      //   if ((value["otp"] ?? false)) {
                                      // return Get.offAll(TwoStepVerify(
                                      //     username: nameController.text,
                                      //     password: passwordController.text,
                                      //   //     sentto: value["sentto"]));
                                      // } else {
                                      //   // errortext =
                                      //   //     'Sorry, ${value["msg"] ?? value["message"]}';
                                      // }

                                      // StatusAlert.show(
                                      //   context,
                                      //   duration: Duration(seconds: 2),
                                      //   title: 'Failed',
                                      //   subtitle: 'Sorry ${value["msg"] ?? value["message"]} ',
                                      //   configuration: IconConfiguration(icon: Icons.warning),
                                      //   maxWidth: 320,
                                      // );
                                    }
                                  });

                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             HomeScreen()));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Color(0xFF7E64D4),
                                  padding: EdgeInsets.zero,
                                  elevation: 5,
                                  shadowColor: Colors.black.withOpacity(0.3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.white,
                                        Colors.white.withOpacity(0.9),
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: logging_on
                                        ? SpinKitThreeBounce(
                                            color: Colors.green,
                                          )
                                        : Text(
                                            'Sign Up',
                                            style: TextStyle(
                                              color: Color(0xFF7E64D4),
                                              fontSize:
                                                  18, // Slightly larger text
                                              fontWeight: FontWeight.bold,
                                              letterSpacing:
                                                  1.2, // Spacing between letters
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Already have an account? ',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    TextSpan(
                                      text: 'Log In',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
