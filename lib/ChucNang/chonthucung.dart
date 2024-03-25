import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'login_7.dart';

class trangChonThuCung extends StatelessWidget {
  const trangChonThuCung({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
            child: IconButton(
          icon: const Icon(
            Icons.chevron_left_sharp,
            size: 40,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        )),
        title: Text("Thú cưng của bạn",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24)),
        centerTitle: true,
        leadingWidth: 60,
        backgroundColor: Color.fromARGB(255,136 ,202, 191),
        actions: [
          IconButton(
              onPressed: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => HomePage3()));
              },
              icon: Icon(CupertinoIcons.add),
              color: Colors.black,
              iconSize: 28)
        ],
      ),
      body: Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: 140,
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                widgetChonThuCung(
                  hinh: 'assets/avtohe.png',
                  ten: 'Mr. Ờ He',
                  trangThai: '2 tuổi - 4kg'
                ),
                widgetChonThuCung(
                  hinh: 'assets/avtohe.png',
                  ten: 'Mr. Ờ He',
                  trangThai: '2 tuổi - 4kg'
                ),
                widgetChonThuCung(
                  hinh: 'assets/avtohe.png',
                  ten: 'Mr. Ờ He',
                  trangThai: '2 tuổi - 4kg'
                ),
                widgetChonThuCung(
                  hinh: 'assets/avtohe.png',
                  ten: 'Mr. Ờ He',
                  trangThai: '2 tuổi - 4kg'
                ),
                widgetChonThuCung(
                  hinh: 'assets/avtohe.png',
                  ten: 'Mr. Ờ He',
                  trangThai: '2 tuổi - 4kg'
                ),
                widgetChonThuCung(
                  hinh: 'assets/avtohe.png',
                  ten: 'Mr. Ờ He',
                  trangThai: '2 tuổi - 4kg'
                ),
                widgetChonThuCung(
                  hinh: 'assets/avtohe.png',
                  ten: 'Mr. Ờ He',
                  trangThai: '2 tuổi - 4kg'
                ),
                widgetChonThuCung(
                  hinh: 'assets/avtohe.png',
                  ten: 'Mr. Ờ He',
                  trangThai: '2 tuổi - 4kg'
                ),
                widgetChonThuCung(
                  hinh: 'assets/avtohe.png',
                  ten: 'Mr. Ờ He',
                  trangThai: '2 tuổi - 4kg'
                ),
                widgetChonThuCung(
                  hinh: 'assets/avtohe.png',
                  ten: 'Mr. Ờ He',
                  trangThai: '2 tuổi - 4kg'
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}


Widget widgetChonThuCung({String hinh='', ten='', trangThai='', gioiTinh='0'}){
  return Container(
      // width: 306,
      // height: 81,
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(20),
      //     color: Color.fromRGBO(155, 210, 218, 1)),
      child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
      child: ElevatedButton(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                child: Container(
                    child: Image.asset(hinh,
                        alignment: Alignment.centerLeft,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    )),
                width: 60,
                height: 60),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(ten,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
                    //textAlign: TextAlign.center,
                    ),
                Text(trangThai,
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.normal)
                    //textAlign: TextAlign.center,
                    ),
              ],
            ),
            SizedBox(width: 60),
            Icon(
              Icons.male,
              color: Colors.blue,
              size: 30,
            ),
          ],
        ),
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Color.fromRGBO(155, 210, 218, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
      
      ),
      ),
      width: 295,
      height: 95,
    );
}
