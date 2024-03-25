
import 'package:thuyngoc/ChucNang/an.dart';
import 'package:thuyngoc/ChucNang/donhang.dart';
import 'package:thuyngoc/Beacon/BeaconMap.dart';
import 'package:thuyngoc/MenuBar/chitietchat.dart';
import 'package:thuyngoc/MenuBar/test.dart';
import 'giaitri.dart';
import 'trangchu.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'chat.dart';
import '../Login/login_2.dart';
import '../Login/login_3.dart';
int _selectedIndex = 1;
 List<Widget>_widgetOptions = <Widget>[
    BeaconMap(),
    //ProfileSettingsPage(),
    TrangChu(),
    //ChitietChat(),
    //DonHanguser(),
     an(),
    GiaiTri(),
    //DonHanguser(),
    

  ];
class Menu extends StatefulWidget{
  const Menu({Key ? key}) :super(key: key);
  //onst MenuBar({super.key});

  @override
  State<Menu> createState() => _MenuBarState();
}
class _MenuBarState extends State<Menu>{
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          
          child: GNav(
            backgroundColor: Colors.white,
            color: Colors.black,
            activeColor: Colors.black,
            tabBackgroundColor: Color.fromARGB(255,136 ,202, 191),
            //Color.fromARGB(255, 18, 20, 40),
            //Color.fromARGB(255, 187, 179, 156),
            gap: 0,
            selectedIndex: _selectedIndex,
            onTabChange: (index){
              setState(() {
                _selectedIndex = index;
              });
              print(index);
            },
            padding: EdgeInsets.all(10),
            tabs: const [
          //     GButton(
          //   icon: Icons.phone_android_rounded,
          //   text: 'Bảng tin',
            
          // ),
          GButton(
            icon: Icons.pin_drop_sharp,
            text: 'Vị trí',
          ),
          
          GButton(
            icon: Icons.home,
            text: 'Trang chủ',
          ),
          GButton(
            icon: Icons.shopping_bag,
            text: 'Cửa hàng',
          ),
          GButton(
            icon: Icons.assignment_add,
            text: 'Đặt lịch',
          ),
          

            ],

          ),
          
        ),
        
    )
    );
  }
}

class MenuBar extends StatelessWidget {
  const MenuBar({Key ?key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
      bottomNavigationBar: const Menu(),
    );
  }
}