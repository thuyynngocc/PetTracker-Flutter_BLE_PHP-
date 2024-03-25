// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'login_2.dart';
// import 'login_5.dart';
// import 'package:http/http.dart' as http;


// class QuenMatKhau extends StatelessWidget {
//   const QuenMatKhau({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController emailController = TextEditingController();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(
//           color: Colors.black,
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//               ),
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 child: const Text(
//                   "Quên mật khẩu ?",
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: 20,
//                 vertical: 10,
//               ),
//               child: Text(
//                 "Đừng lo lắng! Nó xảy ra. Vui lòng nhập địa chỉ email được liên kết với tài khoản của bạn.",
//                 style: TextStyle(
//                   color: Color(0xFF8391A1),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             //email
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF7F8F9),
//                   border: Border.all(
//                     color: const Color(0xFFE8ECF4),
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     left: 10,
//                     right: 10,
//                   ),
//                   child: TextFormField(
//                     controller: emailController,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Email',
//                       hintStyle: TextStyle(
//                         color: Color(0xFF8391A1),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//                 vertical: 5,
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: MaterialButton(
//                       color: const Color.fromARGB(255, 136, 202, 191),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       onPressed: () {
//                         // Call the function to send OTP and navigate to OTP screen
//                         sendOTP(context, emailController.text);
//                       },
//                       child: const Padding(
//                         padding: EdgeInsets.all(15.0),
//                         child: Text(
//                           "Gửi mã",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   "Nhớ mật khẩu ? ",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const Login()));
//                   },
//                   child: const Text(
//                     "Đăng nhập",
//                     style: TextStyle(
//                       color: Color(0xFF35C2C1),
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//  void sendOTP(BuildContext context, String email) {
//   String fakeOTP = '1234';
//   Uri url = Uri.parse('http://localhost/medhealth_db/quen_mk.php');
//   http.post(url, body: {'email': email}).then((response) {
//     Map<String, dynamic> data = jsonDecode(response.body);
//     if (data['success']) {
//       // If OTP sent successfully, navigate to the OTP verification screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => OTP(email: email),
//         ),
//       );
//     } else {
//       // If OTP sending fails, show an error message
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text("Lỗi"),
//           content: Text(data['message']),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text("Đồng ý"),
//             ),
//           ],
//         ),
//       );
//     }
//   }).catchError((error) {
//     // Handle error, show an error message
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Lỗi"),
//         content: Text("Không gửi được OTP. Vui lòng thử lại"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text("Đồng ý"),
//           ),
//         ],
//       ),
//     );
//   });

// }

// }

import 'package:flutter/material.dart';
import 'login_2.dart';
import 'login_5.dart';
class QuenMatKhau extends StatelessWidget {
  const QuenMatKhau({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: const Text(
                  "Quên mật khẩu ?",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Text(
                "Đừng lo lắng! Nó xảy ra. Vui lòng nhập địa chỉ email được liên kết với tài khoản của bạn.",
                style: TextStyle(
                  color: Color(0xFF8391A1),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
            //email
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8F9),
                  border: Border.all(
                    color: const Color(0xFFE8ECF4),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: Color(0xFF8391A1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      color: const Color.fromARGB(255,136 ,202, 191),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OTP()));
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Gửi mã",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Nhớ mật khẩu ? ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Login()));
                  },
                  child: const Text(
                    "Đăng nhập",
                    style: TextStyle(
                      color: Color(0xFF35C2C1),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
