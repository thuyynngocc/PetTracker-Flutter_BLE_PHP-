import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:thuyngoc/Beacon/ScanQr.dart';

class themthietbi extends StatelessWidget {
  const themthietbi({Key ?key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 239, 226, 255),
        title: const SizedBox(
          child: Text('Thêm thiết bị',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.black)),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.chevron_left_sharp,
                size: 40,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.add,
                size: 40,
                color: Colors.black,
              ),
              tooltip: 'Add',
              onPressed: () {
                // Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => const ScanQr()),
                //     );
              }),
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
                        widgetThemThietBi(
                        hinh: 'assets/Thietbi.png',
                         ten: 'Mr. Bảnh Tỏn',
                         trangThai:'Thiết Bị'),
                          widgetThemThietBi(
                        hinh: 'assets/Thietbi.png',
                         ten: 'Mr. Bảnh Tỏn',
                         trangThai:'Thiết Bị'),
                          widgetThemThietBi(
                        hinh: 'assets/Thietbi.png',
                         ten: 'Mr. Bảnh Tỏn',
                         trangThai:'Thiết Bị'),
                          widgetThemThietBi(
                        hinh: 'assets/Thietbi.png',
                         ten: 'Mr. Bảnh Tỏn',
                         trangThai:'Thiết Bị'),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
 
                       
Widget widgetThemThietBi({String hinh='', ten='', trangThai=''}){
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
              CupertinoIcons.bell_circle,
              color: Colors.black,
              size: 30,
            ),
          ],
        ),
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Color.fromARGB(255, 186, 148, 209),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
      
      ),
      ),
      width: 295,
      height: 95,
    );
}

