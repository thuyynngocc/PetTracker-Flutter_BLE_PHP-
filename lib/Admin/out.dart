import 'package:flutter/material.dart';
import 'package:thuyngoc/Login/login_2.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng xuất'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản?',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Xử lý đăng xuất ở đây, ví dụ: quay lại trang đăng nhập
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
              },
              child: Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }
}
