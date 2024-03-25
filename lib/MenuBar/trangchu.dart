import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thuyngoc/ChucNang/donhang.dart';
import 'package:thuyngoc/Login/login.dart';
import 'package:thuyngoc/Login/login_1.dart';
import 'package:thuyngoc/Login/login_3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thuyngoc/MenuBar/chitietchat.dart';
import 'package:thuyngoc/MenuBar/giaitri.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:thuyngoc/MenuBar/notifi_service.dart';
import 'package:thuyngoc/network/api/url_api.dart';
import 'package:thuyngoc/network/model/pref_profile_model.dart';
import 'package:thuyngoc/network/model/tiem_model.dart';
import '../Login/login_2.dart';
import 'package:http/http.dart' as http;
import '../ChucNang/tiem.dart';
import '../ChucNang/thietbi.dart';
import '../ChucNang/an.dart';
import '../ChucNang/didao.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:thuyngoc/Beacon/BeaconMap.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ThietLap extends StatelessWidget {
  const ThietLap({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(children: const [
            Text(
              "Quản lý",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ]),
          const SizedBox(
            height: 12,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust spacing
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Tiem()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 240, 196, 125),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  minimumSize: Size(60, 60), // Adjust button size
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/Tiem.png",
                      height: 38,
                      width: 38,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => thietbi()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 239, 226, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  minimumSize: Size(60, 60), // Adjust button size
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/Thietbi.png",
                      height: 38,
                      width: 38,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DonHanguser()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 208, 230, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  minimumSize: Size(60, 60), // Adjust button size
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/an.png",
                      height: 38,
                      width: 38,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const didao()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 223, 243, 198),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  minimumSize: Size(60, 60),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/Didao.png",
                      height: 38,
                      width: 38,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('  Tiêm'),
              Text('  Thiết Bị'),
              Text('Mua sắm'),
              Text('Đi Dạo')
            ],
          ),
        ],
      ),
    );
  }
}

class LichvsSuKien extends StatefulWidget {
  @override
  _LichvsSuKienState createState() => _LichvsSuKienState();
}

class _LichvsSuKienState extends State<LichvsSuKien> {
  TextEditingController _eventNameController = TextEditingController();
  DateTime kFirstDay = DateTime(2023, 1, 1);
  DateTime kLastDay = DateTime(2023, 12, 31);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<DSTiem> dsTiem = [];
  TimeOfDay parseTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  getTiem() async {
    dsTiem.clear();
    var urlTiem = Uri.parse(BASEURL.apiGetTiem + userID);
    final response = await http.get(urlTiem);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map<String, dynamic> item in data) {
          DateTime ngayTiem = DateTime.parse(item['ngayTiem']);
          TimeOfDay gio = parseTimeOfDay(item['gioTiem']);
          String tenTiem = item['tenTiem'];

          if (!_events.containsKey(ngayTiem)) {
            _events[ngayTiem] = [];
          }

          _events[ngayTiem]?.add({
            'eventName': tenTiem,
            //'eventDateTime': ngayTiem,
            'eventTime': gio,
          });
        }
      });
    }
  }

  List<BookedAppointment> bookedAppointments = [];
  getdatlich() async {
    bookedAppointments.clear();
    var url = Uri.parse(BASEURL.apiGetDichVu + userID);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map<String, dynamic> item in data) {
          DateTime ngayTiem = DateTime.parse(item['ngay']);
          TimeOfDay gio = parseTimeOfDay(item['gio']);
          String tenTiem = item['tendv'];

          if (!_events.containsKey(ngayTiem)) {
            _events[ngayTiem] = [];
          }

          _events[ngayTiem]?.add({
            'eventName': tenTiem,
            //'eventDateTime': ngayTiem,
            'eventTime': gio,
          });
        }
        for (Map<String, dynamic> item in data) {
          bookedAppointments.add(BookedAppointment.fromJson(item));
        }
      });
    }
  }

  void xoaTiem(String model) async {
    var url = Uri.parse(BASEURL.apiXoaTiem);
    final response = await http.post(url, body: {'maTiem': model});
    final data = jsonDecode(response.body);
  }

  late String userID, fullname, email, phone, maTiem;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userID = sharedPreferences.getString(PrefProfile.id) ?? "";

      fullname = sharedPreferences.getString(PrefProfile.fullname) ?? "";

      email = sharedPreferences.getString(PrefProfile.email) ?? "";
      phone = sharedPreferences.getString(PrefProfile.phone) ?? "";
    });
    getTiem();
    getdatlich();
  }

  Icon icon = Icon(Icons.cruelty_free_sharp, color: Colors.black);

  @override
  void initState() {
    super.initState();
    getPref();
    _getEventsForDay(_focusedDay);
  }


  Map<DateTime, List<Map<String, dynamic>>> _events = {};

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    DateTime dateWithoutTime = DateTime(day.year, day.month, day.day);
    return _events[dateWithoutTime] ?? [];
  }

  List<Map<String, dynamic>> _selectedEvents = [];

  void _addEvent(DateTime date, String eventName) {
    // Add print statements for debugging
    print('Đã thêm $eventName thành công');
    setState(() {
      if (!_events.containsKey(date)) {
        _events[date] = [];
      }
      _events[date]?.add({
        'eventName': eventName,
        'eventDateTime': date,
      });
    });

    final payload = 'Event notification for $eventName';
    final notificationId = DateTime.now().millisecondsSinceEpoch &
        0x7FFFFFFF; // Generate a valid 32-bit integer ID
    print('Showing notification for event: $eventName');
    NotificationService().showNotification(
      id: notificationId,
      title: 'Lịch hẹn',
      body: 'Sự kiện: $eventName đã thêm thành công!',
      payLoad: payload,
    );
    
    final morningNotificationId = DateTime.now().millisecondsSinceEpoch;
  final afternoonNotificationId = morningNotificationId + 1;
  final eveningNotificationId = morningNotificationId + 2;

    final notificationService = NotificationService();

    // Schedule notifications for specific times (6:00 AM, 3:00 PM, and 6:00 PM)
    final now = DateTime.now();
    final tz.TZDateTime morningNotification = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      6,
      0,
    );
    final tz.TZDateTime afternoonNotification = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      11,
      0,
    );
    final tz.TZDateTime eveningNotification = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      16,
      0,
    );

    // Schedule morning notification
    notificationService.scheduleNotification(
    id: morningNotificationId,
    title: 'Lịch hẹn',
    body: 'Chào buổi sáng! Đừng quên lịch hẹn "$eventName" hôm nay nhé.',
    scheduledNotificationDateTime: morningNotification,
    payload: payload,
  );


    // Schedule afternoon notification
    notificationService.scheduleNotification(
    id: afternoonNotificationId,
    title: 'Lịch hẹn',
    body: 'Hãy dành thời gian cho lịch hẹn "$eventName" nhé.',
    scheduledNotificationDateTime: afternoonNotification,
    payload: payload,
  );

    // Schedule evening notification
    notificationService.scheduleNotification(
    id: eveningNotificationId,
    title: 'Lịch hẹn',
    body: '"$eventName" đang chờ bạn thực hiện.',
    scheduledNotificationDateTime: eveningNotification,
    payload: payload,
  );

    _updateCalendar();
  }

  void _updateCalendar() {
    setState(() {
      _selectedEvents = _getEventsForDay(_selectedDay ?? DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "Lịch hẹn",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                width: 250,
              ),
              IconButton(
                onPressed: () {
                  _showAddEventDialog(context);
                },
                icon: Icon(Icons.add),
                alignment: Alignment.center,
              ),
            ],
          ),
          TableCalendar(
            // firstDay: kFirstDay,
            // lastDay: kLastDay,
            // focusedDay: _focusedDay,
            firstDay: DateTime.utc(2010, 10, 16),
  lastDay: DateTime.utc(2030, 3, 14),
  focusedDay: DateTime.now(),
            calendarFormat: _calendarFormat,
            locale: 'vi_VI',
            calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.purple.shade300)),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            eventLoader: (day) {
              return _getEventsForDay(day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedEvents = _getEventsForDay(selectedDay);
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 20),
          _buildEventList(),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    if (_selectedEvents.isEmpty) {
      return Column(
        children: [
          Text(
            'Không có sự kiện cho ngày này.',
            style: TextStyle(fontSize: 16),
          ),
          Image.asset('assets/no_event_image.png'),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _selectedEvents.map((event) {
        final eventName = event['eventName'];
        final eventDateTime = event['eventDateTime'];
        final eventTime =
            event['eventTime']; // Thêm dòng này để lấy giờ sự kiện

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            ListTile(
              title: Text(
                eventName != null ? eventName.toString() : '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventDateTime != null
                        ? DateFormat('dd/MM/yyyy').format(eventDateTime)
                        : '',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  if (eventTime != null) // Kiểm tra xem có giờ hay không
                    Text(
                      'Giờ: ${eventTime.hour}:${eventTime.minute}',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  void _showAddEventDialog(BuildContext context) async {
    final selectedDate = await _selectDate(context);
    List<String> predefinedEventNames = ['Ăn', 'Tiêm', 'Đi dạo'];

// Use a variable to store the selected event name
    String selectedEventName = predefinedEventNames.first;

    if (selectedDate != null) {
      final now = DateTime.now();
      if (selectedDate.isBefore(now)) {
        // Ngày được chọn đã qua, hiển thị thông báo
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Thông báo'),
              content: Text(
                  'Sen ơi, ngày bạn chọn đã qua, vui lòng chọn ngày trong tương lai nhé.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Đóng'),
                ),
              ],
            );
          },
        );
      } else {
        // Ngày được chọn là ngày trong tương lai, cho phép người dùng thêm sự kiện
        showDialog(
          //barrierColor: Colors.amber,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Thêm sự kiện'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Chọn sự kiện:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  //...

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (String eventName in predefinedEventNames)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedEventName = eventName;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: selectedEventName == eventName
                                ? Colors.green
                                : Colors.amber,
                            onPrimary: Colors.white,
                          ),
                          child: Text(eventName),
                        ),
                    ],
                  ),

                  SizedBox(height: 16),
                  Text(
                    'Ngày: ${DateFormat('dd/MM/yyyy').format(selectedDate)}',
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    _addEvent(selectedDate, selectedEventName);
                    Navigator.of(context).pop();
                    _updateCalendar();
                  },
                  child: Text('Lưu'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDay ?? _focusedDay,
      firstDate: kFirstDay,
      lastDate: kLastDay,
    );

    return selectedDate;
  }
}

class MenuBar extends StatefulWidget {
  const MenuBar({Key? key}) : super(key: key);

  @override
  State<MenuBar> createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  static const List<Widget> _widgetOptions = <Widget>[
    Login(),
    DangKy(),
    TrangChu(),
    ChitietChat(),
    GiaiTri(),
  ];

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: Colors.white,
            color: Colors.black,
            activeColor: Colors.black,
            tabBackgroundColor: Color.fromARGB(255, 136, 202, 191),
            //Color.fromARGB(255, 18, 20, 40),
            //Color.fromARGB(255, 187, 179, 156),
            gap: 0,
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
              print(index);
            },
            padding: EdgeInsets.all(10),
            tabs: const [
              GButton(
                icon: Icons.phone_android_rounded,
                text: 'Bảng tin',
              ),
              GButton(
                icon: Icons.pin_drop_sharp,
                text: 'Vị trí',
              ),
              GButton(
                icon: Icons.home,
                text: 'Trang chủ',
              ),
              GButton(
                icon: Icons.chat_rounded,
                text: 'Tin nhắn',
              ),
              GButton(
                icon: Icons.account_circle_outlined,
                text: 'Cá nhân',
              ),
            ],
          ),
        ),
        // body: IndexedStack(
        //   index: _selectedIndex,
        //   children: _widgetOptions,
        // ),
      ),
    );
  }
}

class quangcao extends StatefulWidget {
  const quangcao({Key? key});

  @override
  State<quangcao> createState() => _quangcaoState();
}

class _quangcaoState extends State<quangcao> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Sự Kiện",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(15),
          child: ImageSlideshow(
            indicatorColor: Colors.blue,
            onPageChanged: (value) {
              debugPrint('Page changed: $value');
            },
            autoPlayInterval: 3000,
            isLoop: true,
            children: [
              Image.asset(
                'assets/qc1.jpg',
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/qc2.jpg',
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/qc3.jpg',
                fit: BoxFit.cover,
              ),
            ],
          ),
        )
      ],
    ));
  }
}

// class CartPage extends StatelessWidget {
//   List<Product> cartItems = [];
//   CartPage({required this.cartItems});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Giỏ hàng'),
//       ),
//       body: ListView.builder(
//         itemCount: cartItems.length,
//         itemBuilder: (context, index) {
//           final product = cartItems[index];
//           return ListTile(
//             leading: Image.asset('assets/an.png', width: 50, height: 50),
//             title: Text(product.productName),
//             subtitle: Text('\$${product.price.toStringAsFixed(3)}'),
//           );
//         },
//       ),
//     );
//   }
// }

class TrangChu extends StatefulWidget {
  const TrangChu({Key? key}) : super(key: key);

  @override
  State<TrangChu> createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
  Future<void> _refreshData() async {
    // Giả lập việc tải dữ liệu mới từ nguồn dữ liệu
    await Future.delayed(Duration(seconds: 1));

    // Sau khi tải xong, cập nhật danh sách và gọi setState để rebuild giao diện
    setState(() {
      LichvsSuKien();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        leading: Container(
          width: 50,
          margin: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () {
              //   Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const ChitietChat(),
              //   ),
              // );
            },
            icon: Image.asset("assets/Danh dau lich hen HT.png"),
            iconSize: 40,
          ),
        ),
        title: Text(
          'Pet Tracker xin chào !',
          textAlign: TextAlign.center,
          style: GoogleFonts.lovedByTheKing(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leadingWidth: 60,
        backgroundColor: Color.fromARGB(255, 136, 202, 191),
        actions: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0), // Adjust spacing
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChitietChat(),
                ),
              );
            },
            icon: Icon(
              Icons
                  .chat_outlined, // Sử dụng biểu tượng đăng xuất (logout) thay vì output
              color: Colors.black,
            ),
            iconSize: 28,
          ),
          IconButton(
            onPressed: () {
              _handleLogout(context); // Gọi hàm xử lý đăng xuất
            },
            icon: Icon(
              Icons
                  .exit_to_app_rounded, // Sử dụng biểu tượng đăng xuất (logout) thay vì output
              color: Colors.black,
            ),
            iconSize: 28,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                ThietLap(),
                quangcao(),
                LichvsSuKien(),
                //LichHen(),
                SizedBox(height: 265, child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _handleLogout(BuildContext context) async {
  // Hiển thị hộp thoại cảnh báo
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Đăng xuất"),
      content: Text("Bạn có muốn đăng xuất?"),
      actions: [
        TextButton(
          onPressed: () async {
            // Thực hiện đăng xuất ở đây
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('userToken');

            // Hiển thị snackbar thông báo đăng xuất thành công
            final snackBar = SnackBar(
              content: Text('Bạn đã đăng xuất thành công!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            // Điều hướng người dùng đến màn hình đăng nhập (ví dụ: Welcome)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Welcome(),
              ),
            );
          },
          child: Text("Đăng xuất"),
        ),
        TextButton(
          onPressed: () {
            // Đóng hộp thoại cảnh báo nếu người dùng chọn không đăng xuất
            Navigator.of(context).pop();
          },
          child: Text("Hủy"),
        ),
      ],
    ),
  );
}
