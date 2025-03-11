import 'dart:async';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}


class _SplashState extends State<Splash> {
  @override
  void initState() {
    startTimer();
    super.initState();
  }

   startTimer() {
    var duration = const Duration(seconds: 2);
    return Timer(duration, route);
   }

   route (){
    Navigator.of(context)
    .pushReplacementNamed("/login");
   }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Image.asset(
        "images/Log.png",
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.sports_soccer),
          );
        }
      ),
    );
  }
}