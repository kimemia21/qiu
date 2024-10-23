import 'package:application/Models/AccountTypes.dart';
import 'package:application/views/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:qiu/utils/utils.dart';

class SignInScreen extends StatelessWidget {
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
              Image.asset(
                'assets/images/Logo.jpeg',
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
                'Sign In As',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 20),
              buildSignInButton(context, 'Water Service Provider', Colors.blue,
                  Accountypes.WSP),
              buildSignInButton(context, 'Fulfillment Partner',
                  Colors.transparent, Accountypes.FP),
              buildSignInButton(
                  context, 'User/ Consumer', Colors.blue, Accountypes.USER),
              buildSignInButton(
                  context, 'Driver', Colors.transparent, Accountypes.DRIVER),
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

  Widget buildSignInButton(
      BuildContext context, String text, Color color, Accountypes ttype) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
              color: Colors.white,
              width: 1.5,
            ),
          ),
        ),
        onPressed: () async {
          try {
            await LoginPage(context, ttype);
          } catch (e) {
            debugPrint("error loginpage $e");
          }
          
        },
        child:Stack(alignment: Alignment.center,children: [Center(child:  Text(text, style: TextStyle(fontSize: 18),)), Positioned(
          right: 0,
          child:    Icon(Icons.arrow_forward),)],)
        //  Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
           
         
        //   ],
        // ),
      ),
    );
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 100),
                                Image.asset(
                                  'assets/images/Logo.jpeg',
                                  height: 150,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Login',
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
                                SizedBox(height: 40),
                                Text(
                                  'Sign In As',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Spacer(),
                                TextButton(
                                  onPressed: () {
                                    //  Navigator.pushNamed(context, '/signup');
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignupScreen()));
                                  },
                                  child: RichText(
                                    text: TextSpan(
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
                                SizedBox(height: 20),
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
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement sign-up functionality here
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
