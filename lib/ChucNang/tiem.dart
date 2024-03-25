import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:thuyngoc/MenuBar/MenuBar.dart';
import 'package:thuyngoc/MenuBar/trangchu.dart';
import 'package:thuyngoc/chucNang/cartTiem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api/url_api.dart';
import '../network/model/pref_profile_model.dart';
import '../network/model/tiem_model.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _eventNameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _showSnackBar(String tenTiem, DateTime ngay, TimeOfDay gio) {
    final snackBar = SnackBar(
      content: Text('Đã lưu sự kiện: $tenTiem\n' +
          'Ngày: ${ngay.day}/${ngay.month}/${ngay.year}\n' +
          'Giờ: ${gio.hour}:${gio.minute}'),
      // 'Ngày: ${eventDate.day}/${eventDate.month}/${eventDate.year}\n' +
      //'Giờ: ${eventTime.hour}:${eventTime.minute}'),
      action: SnackBarAction(
        label: 'Xem',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditEventScreen(
                dsTiem: DSTiem(
                    maTiem: "",
                    tenTiem: tenTiem,
                    ngay: ngay.toString(),
                    gio: gio.toString()),
              ),
            ),
          );
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
themtiem() async {
  var url = Uri.parse(BASEURL.apiThemTiem);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  final response = await http.post(url, body: {
    "tenTiem": _eventNameController.text,
    "ngayTiem": _selectedDate.toString(),
    "gioTiem": "${_selectedTime.hour}:${_selectedTime.minute}",
    "userID": sharedPreferences.getString(PrefProfile.id) ?? "",
  });

  final data = jsonDecode(response.body);
  int value = data['value'];
  String message = data['message'];

  if (value == 1) {
    // Show a SnackBar for successful addition
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );

    // Navigate to the Tiem screen without displaying the AlertDialog
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Tiem()),
    );
  } else {
    // Show an AlertDialog for unsuccessful addition
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Thông báo!"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  setState(() {});
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thêm mũi tiêm',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 240, 196, 125),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction, // Add this line
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _eventNameController,
                decoration: InputDecoration(
                  labelText: 'Tên mũi tiêm',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Vui lòng nhập tên mũi tiêm';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Chọn ngày và giờ:',
                style: TextStyle(fontSize: 16),
              ),
              Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.calendar_today),
                    label: Text(
                      _selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(_selectedDate)
                          : 'Chọn ngày',
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 203, 173, 103),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _selectTime(context),
                    icon: Icon(Icons.access_time),
                    label: Text(
                      _selectedTime != null
                          ? _selectedTime.format(context)
                          : 'Chọn giờ',
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 203, 173, 103),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, proceed with saving
                      themtiem();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Tiem()));
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 240, 196, 125)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.black),
                  ),
                  child: Text('Lưu'),
                ),
              ),
              SizedBox(
                height: 180,
              ),
              Align(
                alignment: AlignmentDirectional.center,
                child: Image.asset(
                  'assets/add_tiem.png',
                  width: 350,
                  height: 350,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EditEventScreen extends StatefulWidget {
  final DSTiem dsTiem;

  EditEventScreen({required this.dsTiem});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  TextEditingController _eventNameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Icon icon = Icon(Icons.star, color: Colors.black);

  @override
  void initState() {
    super.initState();
    //_eventNameController.text = widget.dsTiem.maTiem;
    //_selectedDate = widget.dsTiem.tenTiem as DateTime;
    //_selectedTime = TimeOfDay.fromDateTime(widget.dsTiem.ngayTiem as DateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa sự kiện'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          child: Column(
            key: _formKey,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _eventNameController,
                decoration: InputDecoration(
                  labelText: 'Tên mũi tiêm',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Vui lòng nhập tên mũi tiêm';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Chọn ngày:',
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text('$_selectedDate'),
              ),
              SizedBox(height: 16),
              Text(
                'Chọn giờ:',
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: Text('$_selectedTime'),
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      String eventName = _eventNameController.text;
                      DateTime updatedEventDate = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        _selectedTime.hour,
                        _selectedTime.minute,
                      );
                      DSTiem updatedEvent = DSTiem(
                          maTiem: "",
                          tenTiem: eventName,
                          ngay: updatedEventDate.toString(),
                          gio: _selectedTime.toString());

                      // Update the event in the events list
                      // eventIndex = SukienList.events.indexOf(widget.event);
                      // if (eventIndex != -1) {
                      //   SukienList.events[eventIndex] = updatedEvent;
                      // }

                      Navigator.pop(context, updatedEvent);
                    }
                  },
                  child: Text('Lưu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        //_selectedTime = TimeOfDay.now(); // Reset selected time when the date changes
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
}

// class SukienList {
//   static List<Sukien> events = [];

//   static void addEvent(Sukien event) {
//     events.add(event);
//   }

//   static void deleteEvent(Sukien event) {
//     events.remove(event);
//   }
// }

class Tiem extends StatefulWidget {
  const Tiem({Key? key}) : super(key: key);

  @override
  _TiemState createState() => _TiemState();
}

class _TiemState extends State<Tiem> {
  List<DSTiem> dsTiem = [];
  getTiem() async {
    dsTiem.clear();
    var urlTiem = Uri.parse(BASEURL.apiGetTiem + userID);
    final response = await http.get(urlTiem);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map<String, dynamic> item in data) {
          dsTiem.add(DSTiem.fromJson(item));
        }
      });
    }
  }

  void xoaTiem(String model) async {
  var url = Uri.parse(BASEURL.apiXoaTiem);
  final response = await http.post(url, body: {'maTiem': model});
  final data = jsonDecode(response.body);
  int value = data['value'];
  String message = data['message'];

 
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2), 
    ),
  );

  if (value == 1) {
    setState(() {
      getPref();
    });
  } else {
    setState(() {
      getPref();
    });
  }
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
  }

  Icon icon = Icon(Icons.cruelty_free_sharp, color: Colors.black);

  @override
  void initState() {
    super.initState();
    getPref();
  }

  bool isEventExists(DSTiem item) {
    for (DSTiem existingEvent in dsTiem) {
      if (existingEvent.maTiem == item.maTiem &&
          existingEvent.tenTiem == item.tenTiem &&
          existingEvent.ngay == item.ngay &&
          existingEvent.gio == item.gio) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 240, 196, 125),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.chevron_left_sharp,
                size: 40,
                color: Colors.black,
              ),
              onPressed: () {
                 Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Menu(),
              ),
            ); 
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: SizedBox(
          child: Image.asset(
            'assets/Tiem.png',
            height: 83,
            width: 73,
          ),
        ),
      ),
      body: dsTiem.isEmpty
    ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
            Image.asset(
              'assets/tiem_rong.jpg', 
              height: 250, 
              width: 250, 
            ),
            Text(
              'Không có mũi tiêm nào.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      )
      
      :ListView.builder(
        itemCount: dsTiem.length,
        padding:
            EdgeInsets.only(top: 15), 
        itemBuilder: (context, index) {
          final x = dsTiem[index];
          return Dismissible(
            key: Key(x.maTiem),
            background: Container(
              color: Colors.blue,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                xoaTiem(x.maTiem);
                //dsTiem.remove(x);
              } else if (direction == DismissDirection.startToEnd) {
                
              }
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Color.fromARGB(255, 255, 231, 174),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 17, 57,
                                70), // Customize the icon background color.
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            icon.icon,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          x.tenTiem,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ngày: ${x.ngay}', //${x.ngay.day}/${x.ngay.month}/${x.ngay.year}
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Giờ: ${x.gio}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newEvent = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEventScreen()),
          );
          if (newEvent != null && !isEventExists(newEvent)) {
            setState(() {
              dsTiem.add(newEvent);
            });
          }
        },
        backgroundColor: Color.fromARGB(255, 240, 196, 125),
        child: Icon(Icons.add),
      ),
    );
  }
}
