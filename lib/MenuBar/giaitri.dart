import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thuyngoc/MenuBar/MenuBar.dart';
import 'dart:convert';

import '../network/api/url_api.dart';
import '../network/model/pref_profile_model.dart';

class GiaiTri extends StatefulWidget {
  const GiaiTri({Key? key});

  @override
  State<GiaiTri> createState() => _GiaiTriState();
}

class _GiaiTriState extends State<GiaiTri> {
  final List<Color> serviceColors = [
    Color.fromARGB(255, 240, 196, 125),
    Color.fromARGB(255, 239, 226, 255),
    Color.fromARGB(255, 208, 230, 255),
    Color.fromARGB(255, 223, 243, 198),
  ];
  void addBookedAppointment(BookedAppointment appointment) {
    setState(() {
      appointment.isApproved = '0';
      bookedAppointments.add(appointment);
    });
  }

  List<BookedAppointment> bookedAppointments = [];

  List<ServiceDetails> serviceDetails = [];

  getdatlich(String tipe) async {
    bookedAppointments.clear();
    var url = Uri.parse(BASEURL.apiGetDichVu + userID);
    final response = await http.post(url, body: {"tipe": tipe});
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map<String, dynamic> item in data) {
          bookedAppointments.add(BookedAppointment.fromJson(item));
        }
      });
    }
  }

  late String userID, fullname, email, phone, maTiem;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userID = sharedPreferences.getString(PrefProfile.id) ?? "";
    fullname = sharedPreferences.getString(PrefProfile.fullname) ?? "";
    email = sharedPreferences.getString(PrefProfile.email) ?? "";
    phone = sharedPreferences.getString(PrefProfile.phone) ?? "";
  }

  getdv() async {
    serviceDetails.clear();
    var url = Uri.parse(BASEURL.apiDichVu);
    final response = await http.post(url);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map<String, dynamic> item in data) {
          serviceDetails.add(ServiceDetails.fromJson(item));
        }
      });
    }
  }

  List<List<DateTime>> bookedTimes = [
    [],
    [],
    [],
    [],
  ];

  List<DateTime> availableDates = [
    DateTime(2023, 10, 19),
    DateTime(2023, 10, 20),
    DateTime(2023, 10, 21),
  ];

  String getServiceName() {
    return "Dịch vụ";
  }

  Future<void> bookAppointment(String serviceName, DateTime date,
      TimeOfDay time, double price, String description) async {
    final url =
        'http://localhost/medhealth_db/datlich.php'; // Thay thế 'URL_CUA_API_CUA_BAN' bằng URL của tệp PHP API của bạn.

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'service_name': serviceName,
        'date': DateFormat('dd-MM-yyyy').format(date),
        'time': time.format(context),
        'price': price.toString(),
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Cuộc hẹn đã được đặt."),
        ),
      );

      final bookedAppointment = BookedAppointment(
        serviceName: serviceName,
        date: date.toString(),
        time: time.toString(),
        isApproved: '0',
        //price: price,
        //description: description,
      );

      setState(() {
        bookedAppointments.add(bookedAppointment);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi khi đặt cuộc hẹn."),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    getdv();
  }

  @override
  Widget build(BuildContext context) {
    final serviceName = getServiceName();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Đặt lịch",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookedAppointmentsScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.assignment_outlined,
              color: Colors.black,
            ),
            iconSize: 28,
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 136, 202, 191),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(serviceDetails.length, (i) {
              final y = serviceDetails[i];
              return SizedBox(
                height: 180,
                child: Card(
                  color: Colors.white,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: ServiceButton(
                      details: y,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BookingPage(
                                serviceIndex: serviceDetails.indexOf(y),
                                serviceName: y.name,
                                availableDates: availableDates,
                                bookedTimes:
                                    bookedTimes[serviceDetails.indexOf(y)],
                                price: y.price,
                                description: y.description,
                              );
                            },
                          ),
                        ).then((bookedAppointment) {
                          if (bookedAppointment != null) {
                            setState(() {
                              bookedAppointments.add(bookedAppointment);
                            });
                          }
                        });
                      },
                      buttonColor: serviceColors[serviceDetails.indexOf(y)],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class BookedAppointmentsScreen extends StatefulWidget {
  @override
  State<BookedAppointmentsScreen> createState() => _BookedAppointmentsScreen();
}

class _BookedAppointmentsScreen extends State<BookedAppointmentsScreen> {
  Future<String> checkApprovalStatus(BookedAppointment appointment) async {
    // Thực hiện kiểm tra trạng thái ở đây
    return appointment.isApproved;
  }

  List<BookedAppointment> bookedAppointments = [];

  getdatlich(String tipe) async {
    bookedAppointments.clear();
    var url = Uri.parse(BASEURL.apiGetDichVu + id.toString());
    final response = await http.post(url, body: {"tipe": tipe});
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map<String, dynamic> item in data) {
          bookedAppointments.add(BookedAppointment.fromJson(item));
        }
      });
    }
  }

  String? id, fullname, phone;

  getPre() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    setState(() {
      id = pre.getString(PrefProfile.id);
      fullname = pre.getString(PrefProfile.fullname);
      phone = pre.getString(PrefProfile.phone);
    });
    getdatlich("TatCa");
  }

  @override
  void initState() {
    if(mau2 == false && mau3 == false )
                        mau1 = true;
    super.initState();
    getPre();
  }
bool mau1 = false;
bool mau2 = false;
bool mau3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lịch đã đặt",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        //backgroundColor: Color.fromARGB(255, 136, 202, 191),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Menu(),
              ),
            );
          },
        ),
      ),
      body: Column(children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    mau1=true;
                      mau2=false;
                      mau3=false;
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
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                   
                    mau2=true;
                      mau1=false;
                      mau3=false;
                    getdatlich("0");
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      mau2==true?Color.fromARGB(255, 49, 117, 195)
                        :Color.fromARGB(255, 240, 247, 255),
                    ),
                  ),
                  child: Text(
                    'Chưa duyệt',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    mau3=true;
                      mau1=false;
                      mau2=false;
                    getdatlich("1");
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                     mau3==true?Color.fromARGB(255, 49, 117, 195)
                        :Color.fromARGB(255, 240, 247, 255),
                    ),
                  ),
                  child: Text(
                    'Đã duyệt',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: bookedAppointments.length,
            itemBuilder: (context, index) {
              final appointment = bookedAppointments[index];

              return FutureBuilder<String>(
                future: checkApprovalStatus(appointment),
                builder: (context, snapshot) {
                  String approvalStatus = "Đang kiểm tra...";
                  Color textColor = Colors.black; // Default text color

                  if (snapshot.hasData) {
                    approvalStatus =
                        snapshot.data == "1" ? "Đã duyệt" : "Chưa duyệt";
                    textColor =
                        snapshot.data == "1" ? Colors.green : Colors.red;
                  }

                  return ListTile(
                    title: Text(
                      appointment.serviceName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Ngày: ${appointment.date} Thời gian: ${appointment.time}",
                    ),
                    trailing: Text(
                      approvalStatus,
                      style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}

class BookedAppointment {
  final String serviceName;
  final String date;
  final String time;
  //final double price;
  //final String description;
  String isApproved;

  BookedAppointment({
    required this.date,
    required this.time,
    required this.serviceName,
    //required this.price,
    //required this.description,
    required this.isApproved,
    //this.isApproved = false,
  });
  factory BookedAppointment.fromJson(json) {
    return BookedAppointment(
      serviceName: json['tendv'],

      date: json['ngay'],
      time: json['gio'],
      isApproved: json['trangthai'],
      //price: json['gia'],
      //description: json['mota'],
    );
  }
}

class ServiceDetails {
  final String ma;
  final String name;
  final String price;
  final String description;

  ServiceDetails({
    required this.ma,
    required this.name,
    required this.price,
    required this.description,
  });

  factory ServiceDetails.fromJson(json) {
    return ServiceDetails(
      ma: json['madv'],
      name: json['tendv'],
      price: json['gia'],
      description: json['mota'],
    );
  }
}

class ServiceButton extends StatelessWidget {
  final ServiceDetails details;
  final VoidCallback onPressed;
  final Color buttonColor;

  ServiceButton({
    required this.details,
    required this.onPressed,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    double price = double.tryParse(details.price) ?? 0.0;

    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Color.fromARGB(255, 228, 243, 238),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      image: DecorationImage(
                        image: AssetImage('assets/bookingg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          details.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        //SizedBox(height: 8),
                        Text(
                          '${price.toStringAsFixed(3)} VNĐ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ServiceDetailPage(details: details),
                              ),
                            );
                          },
                          child: const Text(
                            'Xem chi tiết',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceDetailPage extends StatelessWidget {
  final ServiceDetails details;

  const ServiceDetailPage({Key? key, required this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        double price = double.tryParse(details.price) ?? 0.0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              //title: Text(details.name),
              background: Image.asset(
                'assets/care.png', // Replace with your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        'Tên dịch vụ: ${details.name}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Giá: ${price.toStringAsFixed(3)} VNĐ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Mô tả',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        details.description,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      Text(
                      'Ưu đãi',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red
                      ),
                    ),
                    // Special Offers Section
                    Row(
                      children: [
                        Icon(
                          Icons.local_offer,
                          color: Colors.green,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quà tặng đặc biệt',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              'cho hoá đơn trên 500,000 VNĐ',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                      SizedBox(height: 16),
                      Text(
                        'Đánh giá',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      // Reviews Section
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.person),
                        ),
                        title: Text('Người dùng 1'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow),
                                Icon(Icons.star, color: Colors.yellow),
                                Icon(Icons.star, color: Colors.yellow),
                                Icon(Icons.star, color: Colors.yellow),
                                Icon(Icons.star_half, color: Colors.yellow),
                              ],
                            ),
                            Text('Dịch vụ tốt, rất hài lòng!'),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.person),
                        ),
                        title: Text('Người dùng 2'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow),
                                Icon(Icons.star, color: Colors.yellow),
                                Icon(Icons.star, color: Colors.yellow),
                                Icon(Icons.star_border, color: Colors.yellow),
                                Icon(Icons.star_border, color: Colors.yellow),
                              ],
                            ),
                            Text('Dịch vụ khá, còn cần cải thiện.'),
                          ],
                        ),
                      ),
                      // Add more reviews as needed
                      SizedBox(height: 16),
                      Text(
                      'Thông tin liên hệ',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    // Contact Information Section
                    ListTile(
                      leading: Icon(Icons.phone, color: Colors.green),
                      title: Text('Hotline'),
                      subtitle: Text('0123 456 789'),
                    ),
                    ListTile(
                      leading: Icon(Icons.email, color: Colors.blue),
                      title: Text('Email'),
                      subtitle: Text('care@pettracker.com'),
                    ),
                      SizedBox(height: 16),
                      // Add more sections as needed
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookingPage extends StatefulWidget {
  final int serviceIndex;
  final String serviceName;
  final List<DateTime> availableDates;
  final List<DateTime> bookedTimes;
  final String price;
  final String description;

  const BookingPage(
      {required this.serviceIndex,
      required this.serviceName,
      required this.availableDates,
      required this.bookedTimes,
      required this.price,
      required this.description});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? selectedDate;
  TimeOfDay selectedTime = TimeOfDay.now();
  List<DateTime> availableTimes = [];

  final datePickerController = TextEditingController();
  final timePickerController = TextEditingController();

  final DateTime kStartTime = DateTime(2023, 1, 1, 8, 0);
  final DateTime kEndTime = DateTime(2023, 1, 1, 22, 0);

  late String userID, fullname, email, phone, maTiem;
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userID = sharedPreferences.getString(PrefProfile.id) ?? "";

      fullname = sharedPreferences.getString(PrefProfile.fullname) ?? "";

      email = sharedPreferences.getString(PrefProfile.email) ?? "";
      phone = sharedPreferences.getString(PrefProfile.phone) ?? "";
    });
  }

  void themDatLich() async {
  var url = Uri.parse(BASEURL.apiThemDichVu);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  final response = await http.post(url, body: {
    "ngay": selectedDate.toString(),
    "gio": "${selectedTime.hour}:${selectedTime.minute}",
    "madv": (widget.serviceIndex + 1).toString(),
    "id": sharedPreferences.getString(PrefProfile.id) ?? "",
  });

  final data = jsonDecode(response.body);
  int value = data['value'];
  String message = data['message'];

  if (value == 1) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );

    // Delay the navigation to give time for the user to see the Snackbar
    await Future.delayed(Duration(seconds: 2));

    // Navigate back to the initial page
    Navigator.of(context).popUntil((route) => route.isFirst);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  setState(() {});
}


  @override
  void initState() {
    super.initState();
    if (selectedDate != null) {
      updateAvailableTimes();
    }
    getPref();
  }

  void updateAvailableTimes() {
    int maxBookingsPerTimeSlot = 5;
    availableTimes = [];
    for (DateTime time in widget.availableDates) {
      DateTime startTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        9,
        0,
        0,
      );
      DateTime endTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        17,
        0,
        0,
      );

      while (startTime.isBefore(endTime)) {
        if (!widget.bookedTimes.contains(startTime) &&
            availableTimes.length < maxBookingsPerTimeSlot) {
          availableTimes.add(startTime);
        }
        startTime = startTime.add(Duration(minutes: 30));
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2024),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        datePickerController.text = DateFormat('dd/MM/yyyy').format(picked);
        //selectedTime = null;
        updateAvailableTimes();
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      final selectedDateTime = DateTime(2023, 1, 1, picked.hour, picked.minute);

      if (selectedDateTime.isAfter(kStartTime) &&
          selectedDateTime.isBefore(kEndTime)) {
        setState(() {
          selectedTime = picked;
          timePickerController.text = picked.format(context);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Vui lòng chọn thời gian trong khung giờ hoạt động từ 8:00 AM đến 10:00 PM."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đặt lịch cho ${widget.serviceName}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            Text(
              "Ngày",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: datePickerController,
                    onTap: () {
                      _selectDate();
                    },
                    decoration: InputDecoration(
                      hintText: "Chọn ngày",
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "Thời gian",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: timePickerController,
                    onTap: () {
                      _selectTime();
                    },
                    decoration: InputDecoration(
                      hintText: "Chọn thời gian",
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "Mô tả dịch vụ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              widget.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedDate != null && selectedTime != null) {
                  themDatLich();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Vui lòng chọn ngày và thời gian."),
                    ),
                  );
                }
              },
              child: Text(
                "Đặt lịch",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 136, 202, 191),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
