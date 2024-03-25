import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_1.dart';
import 'login_2.dart';
import 'login_3.dart';

class Welcome1 extends StatefulWidget {
  const Welcome1({Key ?key});

  @override
  State<Welcome1> createState() => _Welcome1State();
}

class _Welcome1State extends State<Welcome1> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Welcome()),
      );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 115, 10, 10),
                child: Text(
                  'Pet Tracker xin chào !',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lovedByTheKing(
                    fontSize: 40,
                  ),
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                child: Image.asset('assets/bg.png'),
              ),
              SizedBox(
                height: 70,
              ),
              // Đặt các phần tử khác ở đây
            ],
          ),
        ),
      ),
    );
  }
}
