// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:thuyngoc/MenuBar/chitietchat.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({Key? key}) : super(key: key);

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
  
//   @override
//   Widget build(BuildContext context) {
//      return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 115, 10, 10),
//                 child: Text(
//                   'Pet Tracker xin chào !',
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.lovedByTheKing(
//                     fontSize: 40,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 70,
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
//                 child: Image.asset('assets/bg.png'),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             chitietchat()), // ChatScreen() là màn hình bạn muốn chuyển đến
//                   );
//                 },
//                 child: Text('Bắt đầu trò chuyện',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),           
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
