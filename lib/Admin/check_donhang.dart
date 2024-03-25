import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:thuyngoc/Admin/giaodien.dart';
import 'package:thuyngoc/network/api/url_api.dart';

class DonHang extends StatefulWidget {
  @override
  _DonHangState createState() => _DonHangState();
}

class _DonHangState extends State<DonHang> {
  List<Order> orders = [];
  bool isLoading = false;

  Future<void> _refreshData() async {
    // Giả lập việc tải dữ liệu mới từ nguồn dữ liệu
    await Future.delayed(Duration(seconds: 1));

    // Sau khi tải xong, cập nhật danh sách và gọi setState để rebuild giao diện
    setState(() {
      
      layHoaDon("TatCa");
    });
  }
  layHoaDon(String tipe) async {
    setState(() {
      isLoading = true;
    });
    orders.clear();
    var urlLayHang = Uri.parse(BASEURL.apiAdminDuyetDonHang);
    try {
      final response = await http.post(urlLayHang, body:{"tipe": tipe});
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          final data = jsonDecode(response.body);
          for (Map item in data) {
            orders.add(Order.fromJson(item));
          }
        });
      }
    } catch (error) {
      print("Error: $error");
      setState(() {
        isLoading = false;
      });
    }
  }


  bool _isPreparing = false;
  bool _isDelivered = false;
  @override
  void initState() {
    // TODO: implement initState
    if(mau2 == false && mau3 == false && mau4 == false)
                        mau1 = true;
    super.initState();
    layHoaDon("TatCa");
  }
  bool mau1 = false;
bool mau2 = false;
bool mau3 = false;

bool mau4 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý đơn hàng'),
        automaticallyImplyLeading: false,
      ),

      body: Column(
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
                      //filterOrders();
                      
                      mau1=true;
                      mau2=false;
                      mau3=false;
                      mau4=false;
                      layHoaDon("TatCa");
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
                      mau2=true;
                      mau1=false;
                      mau3=false;
                      mau4=false;
                      //filterOrders();
                      layHoaDon("1");
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
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
                      //filterOrders();
                      mau3=true;
                      mau1=false;
                      mau2=false;
                      mau4=false;
                      layHoaDon("2");
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        mau3==true?Color.fromARGB(255, 49, 117, 195)
                        :Color.fromARGB(255, 240, 247, 255),
                      ),
                    ),
                    child: Text('Đang chuẩn bị',
                     style: TextStyle(
                        color: Colors.black,
                      ),),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
                      //filterOrders();
                       mau4=true;
                      mau1=false;
                      mau2=false;
                      mau3=false;
                      layHoaDon("3");
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                       mau4==true?Color.fromARGB(255, 49, 117, 195)
                        :Color.fromARGB(255, 240, 247, 255),
                      ),
                    ),
                    child: Text('Đã giao',
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
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return OrderWidget(
                    order: orders[index],
                    onDeliveredChanged: (value) {
                      setState(() {
                        if (value) {
                  } else {
                    orders[index].trangThai = 'Chưa duyệt';
                  }
                });
              },
              onStatusChanged: (isPreparing, isDelivered) {
                setState(() {
                  _isPreparing = isPreparing;
                  _isDelivered = isDelivered;
                });
              },
            );
                  },
                ),
          ),
          ),
        ],
      ),
      // body: isLoading
      //     ? Center(child: CircularProgressIndicator())
      //     : RefreshIndicator(
      //       onRefresh: _refreshData,
      //       child: ListView.builder(
      //           itemCount: orders.length,
      //           itemBuilder: (context, index) {
      //             return OrderWidget(
      //               order: orders[index],
      //               onDeliveredChanged: (value) {
      //                 setState(() {
      //                   if (value) {
      //             } else {
      //               orders[index].trangThai = 'Chưa duyệt';
      //             }
      //           });
      //         },
      //         onStatusChanged: (isPreparing, isDelivered) {
      //           setState(() {
      //             _isPreparing = isPreparing;
      //             _isDelivered = isDelivered;
      //           });
      //         },
      //       );
      //             },
      //           ),
      //     ),
    );
  }
}

class OrderWidget extends StatefulWidget {
  final Order order;
  final Function(bool) onDeliveredChanged;
  OrderWidget(
      {required this.order,
      required this.onDeliveredChanged,
      required Null Function(dynamic isPreparing, dynamic isDelivered)
          onStatusChanged});
  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currencyFormat = NumberFormat("#,##0.000", "en_US");
    var formattedTotalAmount = currencyFormat.format(widget.order.tongTien);
    return ListTile(
      title: Text(
        'Đơn hàng #${widget.order.id}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Khách hàng: ${widget.order.tenKH}'),
          Text('Số điện thoại: ${widget.order.sdt}'),
        ],
      ),
      trailing: Text(
        '${widget.order.trangThai}' == "1"
            ? 'Chưa duyệt'
            : '${widget.order.trangThai}' == "2"
                ? 'Đang chuẩn bị'
                : 'Đã giao',
        style: TextStyle(
          color: widget.order.trangThai == '1'
              ? Colors.red
              : widget.order.trangThai == '2'
                  ? Colors.orange
                  : Colors.green,
          fontWeight: FontWeight.bold, fontSize: 14,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChiTietDonHang(
              order: widget.order,
              onStatusChanged: (isPreparing, isDelivered) {},
            ),
          ),
        );
      },
    );
  }
}

class Order {
  final String id;
  final String tenKH;
  final String sdt;
  final double tongTien;
  String trangThai;

  Order({
    required this.id,
    required this.tenKH,
    required this.sdt,
    required this.tongTien,
    this.trangThai = 'Chưa duyệt',
  });

  factory Order.fromJson(data) {
    return Order(
      id: data['hoaDon'],
      tenKH: data['fullname'],
      sdt: data['phone'],
      tongTien: 0,
      trangThai: data['status'],
    );
  }
}

class Product {
  final String name;
  final String price;
  final String quantity;

  Product({required this.name, required this.price, required this.quantity});

  factory Product.fromJson(data) {
    return Product(
      name: data['tenTA'],
      price: data['gia'],
      quantity: data['soLuong'],
    );
  }
}

class ChiTietDonHang extends StatefulWidget {
  final Order order;
  final NumberFormat currencyFormat = NumberFormat("#,##0.000", "en_US");
  final Function(bool, bool) onStatusChanged;
  ChiTietDonHang({required this.order, required this.onStatusChanged});

  @override
  _ChiTietDonHangState createState() => _ChiTietDonHangState();
}

class _ChiTietDonHangState extends State<ChiTietDonHang> {
    bool isLoading = false;

  late bool _isPreparing;
  late bool _isDelivered;
  List<Product> product = [];

  laySanPhamTrongHoaDon() async {
    product.clear();
    var urlLayHang =
        Uri.parse(BASEURL.apiAdmimChiTietDonHang + widget.order.id);
    try {
      final response = await http.get(urlLayHang);
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          final data = jsonDecode(response.body);
          for (Map item in data) {
            product.add(Product.fromJson(item));
          }
        });
      }
    } catch (error) {
      print("Error: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _isDelivered = widget.order.trangThai == 'Đã giao';
    _isPreparing = widget.order.trangThai == 'Đang chuẩn bị';
    laySanPhamTrongHoaDon();
  }

  @override
  Widget build(BuildContext context) {
    var currencyFormat = NumberFormat("#,##0.000", "en_US");

    double tongtien = 0;
    for (Product item in product) {
      tongtien += double.parse(item.price) * double.parse(item.quantity);
    }
    var formattedTotalAmount = currencyFormat.format(tongtien);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết đơn hàng'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin đơn hàng',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            buildDetailRow('Mã đơn hàng', widget.order.id.toString()),
            buildDetailRow('Khách hàng', widget.order.tenKH),
            buildDetailRow('Tổng tiền', '$formattedTotalAmount VNĐ'),
            buildProductList(product),
            buildDeliveryStatusButtons(),
          ],
        ),
      ),
    );
  }

  capNhatTrangThai(String tipe, String model) async {
    var urlCapNhatSoLuong = Uri.parse(BASEURL.apiAdmimCapNhatDuyetDonHang);
    final response = await http.post(urlCapNhatSoLuong,
        body: {"hoaDon": widget.order.id, "tipe": tipe});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      print(message);
      setState(() {
        // getPre();
        // widget.method();
      });
    } else {
      print(message);
      setState(() {
        //  getPre();
      });
    }
  }
Widget buildDeliveryStatusButtons() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 40),
      Text(
        'Cập nhật trạng thái đơn hàng',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.blue),
      ),
      SizedBox(height: 20),
      Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _updateStatus('Đang chuẩn bị'),
              style: ElevatedButton.styleFrom(
                primary: _isPreparing ? Colors.green : Colors.grey,
                onPrimary: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Đang chuẩn bị',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ),
          SizedBox(width: 10), 
          Expanded(
            child: ElevatedButton(
              onPressed: () => _updateStatus('Đã giao'),
              style: ElevatedButton.styleFrom(
                primary: _isDelivered ? Colors.green : Colors.grey,
                onPrimary: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Đã giao',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}


void _updateStatus(String status) {
  setState(() {
    switch (status) {
      case 'Đang chuẩn bị':
        _isPreparing = true;
        _isDelivered = false;
        widget.order.trangThai = 'Đang chuẩn bị';
        capNhatTrangThai("dangChuanBi", widget.order.id);
        break;
      case 'Đã giao':
        _isDelivered = true;
        _isPreparing = false;
        widget.order.trangThai = 'Đã giao';
        capNhatTrangThai("daGiao", widget.order.id);
        break;
      default:
        _isDelivered = false;
        _isPreparing = false;
        widget.order.trangThai = 'Chưa duyệt';
    }

    widget.onStatusChanged(_isPreparing, _isDelivered);
    
  Navigator.pop(context);
    //Navigator.push(context, MaterialPageRoute(builder: ((context) => DonHang())));
  });
}



  Widget buildProductList(List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40.0),
        Text(
          'Thông tin sản phẩm',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        SizedBox(height: 8.0),
        for (Product product in products)
          buildDetailRow('${product.name} x${product.quantity}',
              '${widget.currencyFormat.format(double.parse(product.price) * double.parse(product.quantity))} VNĐ'),
      ],
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
