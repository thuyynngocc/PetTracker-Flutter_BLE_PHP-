import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thuyngoc/Admin/giaodien.dart';
import 'package:thuyngoc/Login/login_3.dart';
import 'package:thuyngoc/Login/login_4.dart';
import 'package:thuyngoc/MenuBar/MenuBar.dart';

import 'package:thuyngoc/network/api/url_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:thuyngoc/network/model/pref_profile_model.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isAdmin = false; // Đây là quyền hạn của người dùng, ban đầu không phải là admin.


  Future<void> nopDangNhap() async {
    final urlLogin = Uri.parse(BASEURL.apiDangNhap);
    final response = await http.post(urlLogin, body: {
      "email": emailController.text,
      "password": passwordController.text,
    });

    final data = jsonDecode(response.body);
    int? value = data['value'];
    String? message = data['message'];
    String? id = data['id'];
    String? fullname = data['fullname'];
    String? email = data['email'];
    String? phone = data['phone'];
    String? dateCreate = data['dateCreate'];
int? roleId;
if (data['role_id'] is int) {
  roleId = data['role_id'];
} else if (data['role_id'] is String) {
  roleId = int.tryParse(data['role_id']);
}


    if (value == 1 && id != null && fullname != null && email != null && phone != null && dateCreate != null) {
      // Lưu thông tin đăng nhập vào SharedPreferences
      savePrefe(id, fullname, email, phone, dateCreate);
       // Kiểm tra quyền hạn (role_id)
       if (roleId == 1) {
        isAdmin = true;
      } else {
        isAdmin = false;
      }

      // Kiểm tra quyền hạn (ví dụ: isAdmin)
      if (isAdmin) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MenuAdmin()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Menu()));
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Thông báo"),
          content: Text(message ?? "Có lỗi xảy ra"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Đồng ý"),
            )
          ],
        ),
      );
    }
      setState(() {});

  }

  savePrefe(String id, String fullname, String email, String phone, String dateCreate) async {
  SharedPreferences pre = await SharedPreferences.getInstance();
  setState(() {
    pre.setString(PrefProfile.id, id);
    pre.setString(PrefProfile.fullname, fullname);
    pre.setString(PrefProfile.email, email);
    pre.setString(PrefProfile.phone, phone);
    pre.setString(PrefProfile.dateCreate, dateCreate);
  });
}



  bool _anMK = true;
  Color mau = Color(0xFF8391A1);
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: const Text(
                  'Xin chào !',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8F9),
                  border: Border.all(
                    color: Color(0xFFE8ECF4),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: TextFormField(
                    controller: emailController,
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
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8F9),
                  border: Border.all(
                    color: Color(0xFFE8ECF4),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: _anMK,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Mật khẩu',
                      hintStyle: TextStyle(
                        color: Color(0xFF8391A1),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _anMK ? Icons.visibility : Icons.visibility_off,
                          color: mau,
                        ),
                        onPressed: () {
                          setState(() {
                            _anMK = !_anMK;
                            mau = !_anMK
                                ? Color.fromARGB(255, 74, 144, 224)
                                : Color(0xFF8391A1);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QuenMatKhau()));
                  },
                  child: const Text(
                    'Quên mật khẩu ?',
                    style: TextStyle(
                      color: Color(0xFF6A707C),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(children: [
                Expanded(
                  child: MaterialButton(
                    color: Color.fromARGB(255, 136, 202, 191),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onPressed: () {
                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Cảnh báo"),
                                  content: Text("Không được để trống"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Đồng ý"))
                                  ],
                                ));
                      } else {
                        nopDangNhap();
                      }
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => Menu()));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Đăng nhập',
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
            SizedBox(height: 20),
            //login button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Row(
                children: const [
                  Expanded(
                    child: Divider(
                      color: Color(0xFFE8ECF4),
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Text('Hoặc đăng nhập với'),
                  ),
                  Expanded(
                    child: Divider(
                      color: Color(0xFFE8ECF4),
                      thickness: 1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFE8ECF4),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          'assets/fb.png',
                          height: 32,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFE8ECF4),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          'assets/google.png',
                          height: 32,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFE8ECF4),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          'assets/apple.png',
                          height: 32,
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
                  "Bạn có tài khoản chưa ?",
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
                            builder: (context) => const DangKy()));
                  },
                  child: const Text(
                    " Đăng ký",
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
