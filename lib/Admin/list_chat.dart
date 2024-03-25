import 'package:flutter/material.dart';
import 'package:thuyngoc/Admin/chatadmin.dart';

class AdminUserSelectionPage extends StatefulWidget {
  @override
  _AdminUserSelectionPageState createState() => _AdminUserSelectionPageState();
}

class _AdminUserSelectionPageState extends State<AdminUserSelectionPage> {
  List<UserInfo> userList = [
    UserInfo(name: 'User 1', replied: false),
    UserInfo(name: 'User 2', replied: true),
    UserInfo(name: 'User 3', replied: true),
    UserInfo(name: 'User 4', replied: false),
    UserInfo(name: 'User 5', replied: true),
    // Thêm danh sách người dùng khác tùy theo nhu cầu
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tư vấn'),
                automaticallyImplyLeading: false,

      ),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          final user = userList[index];

          return ListTile(
            title: Text(
              user.name,
              style: TextStyle(
                fontWeight: user.replied ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            onTap: () {
              // Khi bạn nhấn vào dòng danh sách, chuyển sang trang chat
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AdminChatPage(), // Truyền tên người dùng cho trang chat
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class UserInfo {
  final String name;
  final bool replied;

  UserInfo({required this.name, required this.replied});
}
