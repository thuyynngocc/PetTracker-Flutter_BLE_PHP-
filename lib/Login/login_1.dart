import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_2.dart';
import 'login_3.dart';

class Welcome extends StatelessWidget{
  const Welcome({Key ? key}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(10, 115, 10, 10),
          child: Text('Pet Tracker xin chào !',
            textAlign: TextAlign.center,
            style: GoogleFonts.lovedByTheKing(
              fontSize: 40,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          child: Image.asset('assets/Logo.png'),
        ),
        SizedBox(
          height: 70,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Row(children: [
            Expanded(
              child: MaterialButton(
                color: Color.fromARGB(255, 136, 202, 191),              
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onPressed: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const Login()));
                },
                child: const Padding(padding: EdgeInsets.all(15.0),
                child: Text('Đăng nhập',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                ),
              ),
              )
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
          child: Row(children: [
            Expanded(
              child: MaterialButton(
                color: Color.fromARGB(255, 136, 202, 191),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
                ),
                onPressed: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const DangKy()));
                },
                child: const Padding(padding: EdgeInsets.all(15.0),
                child: Text('Đăng ký',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    // color: Color.fromRGBO(217, 237, 233, 1),
                  ),
                ),
                ),
              ),
              )
          ]),
        ),
        SizedBox(height: 40,),
        const Spacer(),
        // GestureDetector(
        //   onTap: () {},
        //   child: const Text(
        //     'Tiếp tục với khách',
        //     style: TextStyle(
        //       color: Color.fromRGBO(124, 135, 132, 1),
        //     ),
        //   ),
        // ),
        const Spacer(),
      ],)),
    );
  }
}
