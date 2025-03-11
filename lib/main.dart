import 'package:firebase_core/firebase_core.dart';
import 'package:sportpro/forgotpassword.dart';
import 'package:sportpro/login.dart';
import 'package:sportpro/onboardScreen.dart';
import 'package:sportpro/pages/grounds.dart';
import 'package:sportpro/pages/home.dart';
import 'package:sportpro/pages/store.dart';
import 'package:sportpro/splash.dart';
import 'package:sportpro/try/try.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'register.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefsService = await PreferencesService.init();
  runApp(MyApp(prefsService: prefsService));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required PreferencesService prefsService});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      //darkTheme: ThemeData(brightness: Brightness.dark),

      debugShowCheckedModeBanner: false,
      //home: HomePage(),
       routes: {
         "/": (context) => const Splash(),
         "/onboardScreen": (context) => const Onboardscreen(),
         "/login": (context) => const Login(),
         "/register":(context) => const Register(),
         "/forgotpassword":(context) => const ForgotPassword(),
         "/home": (context) => const Home(),
         "/grounds": (context) => const Grounds(),
         "/store": (context) => const Store(),
       },
    );
  }
}


