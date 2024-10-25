import 'package:application/views/widgets/Models/AccountTypes.dart';
import 'package:application/views/login.dart';
import 'package:application/views/signinpage.dart';
import 'package:application/views/widgets/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:qiu/utils/utils.dart';

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
  String lat = "";
  String long = "";

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
              Image.asset(
                'assets/images/Logo.jpeg',
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
              if (accounttype == null) ...ListOptions() else ...ListSelection(),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                },
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Already have an account?",
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
          await LoginPage(Get.context!, ttype);
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
      return [
        CustomTextfield(
          myController: name,
          hintText: "Company Name",
        ),
        CustomTextfield(
          myController: quality,
          hintText: "Water Quality",
        ),
        CustomTextfield(
          myController: source,
          hintText: "Water source",
        ),
        CustomTextfield(
          myController: address,
          hintText: "Address",
        ),
        CustomButton(context, "Sign Up", () {
          // printLog("sign up wsp");
          if (name.text.trim() == "") {
            return false;
          }
        })
      ];
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
                                                SignupScreen()));
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

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement sign-up functionality here
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
