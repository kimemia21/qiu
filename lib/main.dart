import 'package:application/Authentication/Splash.dart';
import 'package:application/Authentication/signinUpPage.dart';
import 'package:application/comms/notifications.dart';
import 'package:application/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'utils/utils.dart';

import 'views/state/appbloc.dart';
import 'views/widgets/Orders/orders.dart';
import 'views/widgets/WSP/wsp_orders.dart';
import 'views/widgets/Fps/drivers/DriverProfile.dart';
import 'views/widgets/Fps/drivers/drivers.dart';
import 'views/widgets/trucks/Trucks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Future.delayed(const Duration(seconds: 1));

  // NotificationService().initialize();

  NotificationService.initialize();

  // my_firebase_token = await NotificationService.getFirebasetoken();
  // printLog("my_firebase_token ${my_firebase_token}");

  await LocalStorage.init();
  current_role = LocalStorage().getString("current_role");
  current_role = current_role == "" ? "SC" : current_role;

  printLog("Init user role ${current_role}");

  // current_role = "SC";
  // await LocalStorage().setString("current_role", current_role);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // .kimemia run using fvm
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (context) => Appbloc())],
        child: MaterialApp(
            title: 'Qiu',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: SplashScreen())
            // SignUpScreen()) // SplashScreen()),
        );
  }
}
