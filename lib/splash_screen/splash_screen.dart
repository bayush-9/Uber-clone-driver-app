import 'dart:async';

import 'package:drivers_app/authentication/login_screen.dart';
import 'package:drivers_app/global/globals.dart';
import 'package:drivers_app/main_screens/main_screen.dart';
import 'package:flutter/material.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(
      Duration(seconds: 3),
      () async {
        if (fauth.currentUser != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => MainScreen()));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => LoginScreen()));
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo1.png'),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Uber",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
