import 'package:flutter/material.dart';

class ProfileSettingsPage extends StatefulWidget {
  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  String selectedPetType = 'Chó'; // Loại vật nuôi mặc định
  TextEditingController _nameController = TextEditingController();
  TextEditingController _deviceNameController = TextEditingController();

  List<String> petTypes = ['Chó', 'Mèo', 'Chim', 'Rùa', 'Cá'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thiết lập trang cá nhân'),
        backgroundColor: Color.fromARGB(255,136 ,202, 191), // Màu nền của thanh tiêu đề
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Loại vật nuôi:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), // Màu chữ và font-weight
            ),
            DropdownButton<String>(
              value: selectedPetType,
              onChanged: (String ? newValue) {
                setState(() {
                  selectedPetType = newValue ?? '';
                });
              },
              items: petTypes.map((String petType) {
                return DropdownMenuItem<String>(
                  value: petType,
                  child: Text(petType),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text(
              'Tên của bạn:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Nhập tên của bạn',
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Tên vật nuôi:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Nhập tên vật nuôi',
              ),
            ),
            SizedBox(height: 16.0),

            Text(
              'Tên thiết bị:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextFormField(
              controller: _deviceNameController,
              decoration: InputDecoration(
                hintText: 'Nhập tên thiết bị',
              ),
            ),
            SizedBox(height: 24.0),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      color: Color.fromARGB(255,136 ,202, 191),// Màu nền của nút Lưu
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onPressed: () {
                        // Xử lý lưu thông tin trang cá nhân ở đây
                        String petType = selectedPetType;
                        String petName = _nameController.text;
                        String deviceName = _deviceNameController.text;
                        // Thực hiện lưu thông tin trang cá nhân
                        print('Loại vật nuôi: $petType');
                        print('Tên vật nuôi: $petName');
                        print('Tên thiết bị: $deviceName');
                      },
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Lưu",
                          style: TextStyle(
                            color: Colors.white, // Màu chữ của nút Lưu
                            fontSize: 16,
                          ),
                        ),
                      ),
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

void main() {
  runApp(MaterialApp(
    title: 'Profile Settings',
    home: ProfileSettingsPage(),
  ));
}
