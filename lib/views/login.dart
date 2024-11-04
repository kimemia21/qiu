import 'dart:convert';
import 'dart:io';
import 'package:application/views/widgets/Models/AccountTypes.dart';
import 'package:application/views/widgets/homepage/AppNav.dart';
import 'package:application/views/widgets/homepage/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:qiu/comms/credentials.dart';

import 'widgets/globals.dart';

Future<dynamic> LoginPage(
    BuildContext context, Accountypes qiuaccountType) async {
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      isDismissible: true,
      showDragHandle: true,
      // enableDrag:,
      isScrollControlled: true,
      builder: (context) => Container(
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
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: LoginPageInfo(
                  qiuaccountType: qiuaccountType,
                )),
          ));
}

class LoginPageInfo extends StatefulWidget {
  const LoginPageInfo({
    Key? key,
    required this.qiuaccountType,
  }) : super(key: key);
  final Accountypes qiuaccountType;
  @override
  State<LoginPageInfo> createState() => _LoginPageInfoState();
}

class _LoginPageInfoState extends State<LoginPageInfo> {
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
  void initState() {
    super.initState();

    setState(() {
      if (widget.qiuaccountType == Accountypes.FP) {
        title = "Fulfilment Partner";
      } else if (widget.qiuaccountType == Accountypes.DRIVER) {
        title = "Driver";
      } else if (widget.qiuaccountType == Accountypes.USER) {
        title = "User";
      } else if (widget.qiuaccountType == Accountypes.WSP) {
        title = "Water Service Provider";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: 0.75,
        widthFactor: 1,
        child: Form(
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
                        hintText: " Username",
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
                                  "uname": uname.text.trim(),
                                  "upass": upass.text.trim()
                                };
                                Future.delayed(Duration(seconds: 3))
                                    .then((onValue) {
                                  setState(() {
                                    loginin = false;
                                  });
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (ctx) => HomeScreen(),
                                    ),
                                  );
                                });

                                // await comms_repo.loginUser("login", {
                                //   "uname": uname.text.trim(),
                                //   "upass": upass.text.trim()
                                // })
                                // .then((value) async {
                                //   setState(() {
                                //     loginin = false;
                                //   });

                                //   // printLog("USer ifo $value");

                                //   if (value["rsp"]) {
                                //     if (value["data"].length > 0) {
                                //       // Creating a Technician instance from JSON

                                //       // Navigator.of(context).pushReplacement(
                                //       //   MaterialPageRoute(
                                //       //     builder: (ctx) => const HomeScreen(),
                                //       //   ),
                                //       // );
                                //     } else {
                                //       // CoolAlert.show(
                                //       //   context: context,
                                //       //   type: CoolAlertType.error,
                                //       //   backgroundColor:
                                //       //       const Color.fromARGB(255, 51, 83, 142),
                                //       //   text: "Unknown User Credentials",
                                //       //   autoCloseDuration:
                                //       //       const Duration(seconds: 2),
                                //       // );
                                //     }
                                //   } else {
                                //     // CoolAlert.show(
                                //     //   context: context,
                                //     //   type: CoolAlertType.error,
                                //     //   backgroundColor:
                                //     //       const Color.fromARGB(255, 51, 83, 142),
                                //     //   text: value["msg"],
                                //     //   autoCloseDuration: const Duration(seconds: 2),
                                //     // );
                                //   }
                                // });
                              }
                            },
                          ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          )),
        ));
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}
