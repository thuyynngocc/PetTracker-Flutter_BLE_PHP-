import 'package:flutter/material.dart';
import 'package:thuyngoc/Admin/chatadmin.dart';
import 'package:thuyngoc/Admin/check_donhang.dart';
import 'package:thuyngoc/Admin/check_lichhen.dart';
import 'package:thuyngoc/Admin/list_chat.dart';
import 'package:thuyngoc/Admin/out.dart';

class MenuAdmin extends StatefulWidget {
  const MenuAdmin({Key? key}) : super(key: key);

  @override
  State<MenuAdmin> createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuAdmin> {
  int _selectedIndex = 0; 
  bool isLoggedIn = true; 

  final List<Widget> _widgetOptions = <Widget>[
    DonHang(), 
    //AdminUserSelectionPage(), 
    DanhSachLich(), 
    LogoutPage(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Đơn hàng', // Nhãn của mục "Đơn hàng"
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.chat_rounded),
          //   label: 'Trò chuyện',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_add),
            label: 'Lịch hẹn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.output),
            label: 'Đăng xuất',
          ),
          // Thêm các tab khác (nếu cần)
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 72, 104, 99),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
