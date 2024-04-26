import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 2),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const HomeScreen() ,));
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height *1;
    // final width = MediaQuery.of(context).size.height *1;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/splash_pic.jpg',
            fit: BoxFit.cover,
            height: height *.5,
          ),
          const SizedBox(
            height: 20,
          ),
          Text('TOP HEADLINES', style: GoogleFonts.anton(letterSpacing:.6, color: Colors.grey.shade700)),

          SizedBox(
            height: height * 0.04,
          ),

          const SpinKitChasingDots(
            color: Colors.blue,
            size: 50,
          ),
        ],
      ),
    );
  }
}
