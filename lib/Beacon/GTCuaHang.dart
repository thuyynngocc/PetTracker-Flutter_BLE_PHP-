import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreInfoScreen extends StatelessWidget {
  // Hàm mở ứng dụng điện thoại để gọi điện
  void _launchPhone() async {
    const phoneNumber = '0346676839';
    if (await canLaunch('tel:$phoneNumber')) {
      await launch('tel:$phoneNumber');
    } else {
      throw 'Không thể mở ứng dụng điện thoại.';
    }
  }

  // Hàm mở ứng dụng để hiển thị địa chỉ cửa hàng trên bản đồ
  void _launchMap() async {
    const storeAddress = 'HUTECH - Đại học Công nghệ TP.HCM (Thu Duc Campus)'; // Thay Your Store Address bằng địa chỉ cửa hàng thực tế
    final encodedAddress = Uri.encodeFull(storeAddress);
    final url = 'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Không thể mở ứng dụng bản đồ.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product_image',
                child: Image.asset(
                  'assets/beacon.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 16.0),
                buildTitle('BLE Beacon'),
                SizedBox(height: 8.0),
                buildDescription('A Bluetooth Low Energy (BLE) beacon for location tracking.'),
                SizedBox(height: 16.0),
                buildPriceTile('Giá: \99.000 VNĐ', 'Giá có thể thay đổi theo tính năng và dung lượng pin.'),
                buildFeatureTile('Kích Thước: Nhỏ gọn', Icons.straighten, Colors.blue),
                buildFeatureTile('Màu Sắc: Đen', Icons.color_lens, Colors.black),
                Divider(height: 1.0, color: Colors.grey),
                buildAdvantagesSection(),
                SizedBox(height: 16.0),
                SizedBox(height: 16.0),
                buildStoreAddress(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _launchPhone,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_in_talk),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
Widget buildStoreAddress() {
  return Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Địa chỉ cửa hàng:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            GestureDetector(
              onTap: _launchMap,
              child: Row(
                children: [
                  Text(
                    'Xem vị trí',
                    style: TextStyle(fontSize: 16.0),
                  ),
                                    SizedBox(width: 8.0),

                  Icon(Icons.location_on, size: 24.0, color: Colors.red),
                  
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Text(
          'HUTECH - Đại học Công nghệ TP.HCM (Thu Duc Campus)\nHUTECH - Đại học Công nghệ TP.HCM (Sai Gon Campus)',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16.0),
        // ElevatedButton(
        //   onPressed: _launchMap,
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Icon(Icons.location_on, size: 24.0),
        //       SizedBox(width: 8.0),
        //       Text(
        //         'Xem vị trí',
        //         style: TextStyle(fontSize: 16.0),
        //       ),
        //     ],
        //   ),
        //   style: ElevatedButton.styleFrom(
        //     primary: Color.fromARGB(255, 249, 165, 144),
        //   ),
        // ),
      ],
    ),
  );
}


  Widget buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget buildDescription(String description) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        description,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget buildPriceTile(String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 18.0, color: Colors.red,fontWeight: FontWeight.bold),
      ),
      // subtitle: Text(
      //   subtitle,
      //   style: TextStyle(fontSize: 16.0),
      // ),
      //trailing: Icon(Icons.attach_money, color: Colors.green),
    );
  }

  Widget buildFeatureTile(String title, IconData icon, Color iconColor) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Icon(icon, color: iconColor),
    );
  }
Widget buildAdvantagesSection() {
  return Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ưu điểm:',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8.0),
        buildAdvantage('1. Tiêu thụ năng lượng thấp giúp kéo dài thời lượng pin.'),
        buildAdvantage('2. Kết nối nhanh chóng và ổn định.'),
        buildAdvantage('3. Tương thích rộng rãi với đa dạng thiết bị di động.'),
        buildAdvantage('4. Độ chính xác cao trong việc định vị vị trí của thú cưng.'),
        buildAdvantage('5. Khả năng theo dõi sức khỏe của thú cưng qua thời gian.'),
        buildAdvantage('6. Gửi cảnh báo khi thú cưng đi ra khỏi phạm vi an toàn.'),
      ],
    ),
  );
}


  Widget buildAdvantage(String advantage) {
    return Text(
      advantage,
      style: TextStyle(fontSize: 16.0),
    );
  }
  
}
