import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:thuyngoc/network/api/url_api.dart';

class DanhSachLich extends StatefulWidget {
  @override
  _DanhSachLichState createState() => _DanhSachLichState();
}

class _DanhSachLichState extends State<DanhSachLich> {
  List<Appointment> bookedAppointments = [];
  bool isLoading = false;

 Future<void> _refreshData() async {
    // Giả lập việc tải dữ liệu mới từ nguồn dữ liệu
    await Future.delayed(Duration(seconds: 1));

    // Sau khi tải xong, cập nhật danh sách và gọi setState để rebuild giao diện
    setState(() {
      getdatlich("TatCa");
    });
  }
  getdatlich(String tipe) async {
    setState(() {
      isLoading = true;
    });
    bookedAppointments.clear();
    var url = Uri.parse(BASEURL.apiAdmimDuyetDatLich);
    final response = await http.post(url, body:{"tipe":tipe});
    if (response.statusCode == 200) {
      setState(() {
          isLoading = false;
        final data = jsonDecode(response.body);
        for (Map item in data) {
          bookedAppointments.add(Appointment.fromJson(item));
        }
      });
    }
  }
   capNhatTrangThaiDatLich(String tipe, String model) async {
  var urlCapNhatSoLuong = Uri.parse(BASEURL.apiAdminCapNhatTrangThaiDatLich);
  final response =
      await http.post(urlCapNhatSoLuong, body: {"madl": model, "tipe": tipe});
  final data = jsonDecode(response.body);
  int value = data['value'];
  String message = data['message'];

  if (value == 1) {
    // Show Snackbar on successful approval
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã duyệt thành công'),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );

    setState(() {
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Duyệt không thành công: $message'),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );

    setState(() {
    });
  }
}
bool mau1 = false;
bool mau2 = false;
bool mau3 = false;

  @override
  void initState() {
    // TODO: implement initState
    if(mau2 == false && mau3 == false )
                        mau1 = true;
    super.initState();
    getdatlich("TatCa");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lịch đã đặt"),
        automaticallyImplyLeading: false,
      ),
      body:Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      mau1=true;
                      mau2=false;
                      mau3=false;
                      //filterOrders();
                      getdatlich("TatCa");
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        mau1==true?Color.fromARGB(255, 49, 117, 195)
                        :Color.fromARGB(255, 240, 247, 255),
                      ),
                    ),
                    child: Text(
                      'Tất cả',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
                      //filterOrders();
                      mau2=true;
                      mau1=false;
                      mau3=false;
                      getdatlich("0");
                    },
                    style: ButtonStyle(
                      backgroundColor:MaterialStateProperty.all<Color>(
                        mau2==true?Color.fromARGB(255, 49, 117, 195)
                        :Color.fromARGB(255, 240, 247, 255),
                      ),
                    ),
                    child: Text('Chưa duyệt',
                     style: TextStyle(
                        color: Colors.black,
                      ),),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
                      mau3=true;
                      mau2=false;
                      mau1=false;
                      //filterOrders();
                      getdatlich("1");
                    },
                    
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                       mau3==true?Color.fromARGB(255, 49, 117, 195)
                        :Color.fromARGB(255, 240, 247, 255),
                      ),
                    ),
                    child: Text('Đã duyệt',
                     style: TextStyle(
                        color: Colors.black,
                      ),),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.builder(
        itemCount: bookedAppointments.length,
        itemBuilder: (context, index) {
          final appointment = bookedAppointments[index];
          String approvalStatus = appointment.status ?? "Đang kiểm tra..."; // Mặc định hiển thị "Đang kiểm tra" cho đến khi kiểm tra xong.
          return ListTile(
            title: Text(appointment.serviceName + " - " + appointment.fullname,style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Ngày: ${appointment.date} \nThời gian: ${appointment.time}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                approvalStatus == "1" ?
                Row(
                  children: [
                                        Text('Đã duyệt    ', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14),),

                    IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                   
                    },
                  ),],
                ):
                Row(
                  children:[ 
                    Text('Chưa duyệt', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),),
                    IconButton(
                    icon: Icon(Icons.draw_outlined, color: Colors.red),
                    onPressed: () {
                      // Xử lý không duyệt yêu cầu ở đây
                      setState(() {
                
                      capNhatTrangThaiDatLich("duyet", appointment.id);
                        appointment.status = "Không duyệt";
                      });
                    },
                  ),],
                ),
              ],
            ),
          );
        },
      ),
          ),
          ),
        ],
      ),
      // body: ListView.builder(
      //   itemCount: bookedAppointments.length,
      //   itemBuilder: (context, index) {
      //     final appointment = bookedAppointments[index];
      //     String approvalStatus = appointment.status ?? "Đang kiểm tra..."; // Mặc định hiển thị "Đang kiểm tra" cho đến khi kiểm tra xong.
      //     return ListTile(
      //       title: Text(appointment.serviceName),
      //       subtitle: Text("Ngày: ${appointment.date} \nThời gian: ${appointment.time}"),
      //       trailing: Row(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           IconButton(
      //             icon: Icon(Icons.check, color: Colors.green),
      //             onPressed: () {
      //               // Xử lý duyệt yêu cầu ở đây
      //               setState(() {
      //                 appointment.status = "Đã duyệt";
      //               });
      //             },
      //           ),
      //           IconButton(
      //             icon: Icon(Icons.clear, color: Colors.red),
      //             onPressed: () {
      //               // Xử lý không duyệt yêu cầu ở đây
      //               setState(() {
      //                 appointment.status = "Không duyệt";
      //               });
      //             },
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // ),
    );
  }
}

class Appointment {
  final String id;
  final String fullname;
  final String serviceName;
  final String date;
  final String time;
  String status; // Trạng thái của cuộc hẹn (null: Đang kiểm tra, "Đã duyệt", "Không duyệt")

  //Appointment({required this.serviceName, required this.date, required this.time, this.status, required price, required description, required bool isApproved, required id});

  Appointment({required this.id, required this.fullname,required this.serviceName, required this.date, required this.time, required this.status});
  factory Appointment.fromJson(data) {
    return Appointment(
      id: data['madl'],
      fullname: data['fullname'],
      serviceName: data['tendv'],
      date: data['ngay'],
      time: data['gio'],
      status: data['trangthai'],
    );
  }
}
