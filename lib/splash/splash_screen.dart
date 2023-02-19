import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mkd_seller_app/authentication/auth_screen.dart';
import 'package:mkd_seller_app/global/global.dart';
import 'package:mkd_seller_app/screens/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 8), () async {
      //if seller is already logged in
      if (firebaseAuth.currentUser != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => const HomeScreen(),
            ));
      } else {
        // if seller is not authenticated
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => const AuthScreen(),
            ));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('images/splash.jpg'),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Sell food online',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Signatra',
                  color: Colors.black54,
                  letterSpacing: 3),
            ),
          )
        ]),
      ),
    );
  }
}
