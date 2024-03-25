import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thuyngoc/ChucNang/Cart_model.dart';
import 'package:thuyngoc/ChucNang/an.dart';
import 'package:thuyngoc/ChucNang/thanhcong.dart';
import 'package:thuyngoc/MenuBar/MenuBar.dart';
import 'package:thuyngoc/network/api/url_api.dart';
import 'package:thuyngoc/network/model/pref_profile_model.dart';

class GioHang extends StatefulWidget {
  final VoidCallback method;
  GioHang(this.method);
  @override
  _GioHangState createState() => _GioHangState();
}

class _GioHangState extends State<GioHang> {
  //thongtin nguoi dung
  String? id, fullname, phone;
  getPre() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    setState(() {
      id = pre.getString(PrefProfile.id);
      fullname = pre.getString(PrefProfile.fullname);
      phone = pre.getString(PrefProfile.phone);
    });
    layHang();
  }

  List<CartModel> dsHang = [];
  layHang() async {
    dsHang.clear();
    var urlLayHang = Uri.parse(BASEURL.apiGioHang + id.toString());
    final response = await http.get(urlLayHang);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map item in data) {
          dsHang.add(CartModel.fromJson(item));
        }
      });
    }
  }

  xoaGioHang(String model) async {
    var urlCapNhatSoLuong = Uri.parse(BASEURL.apiXoaGioHang);
    final response =
        await http.post(urlCapNhatSoLuong, body: {"maGioHang": model});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      print(message);
      setState(() {
        getPre();
      });
    } else {
      print(message);
      setState(() {
        getPre();
      });
    }
  }

  capNhatSoLuong(String tipe, String model) async {
    var urlCapNhatSoLuong = Uri.parse(BASEURL.apiCapNhatGioHang);
    final response = await http
        .post(urlCapNhatSoLuong, body: {"maGioHang": model, "tipe": tipe});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      print(message);
      setState(() {
        getPre();
        widget.method();
      });
    } else {
      print(message);
      setState(() {
        getPre();
      });
    }
  }

  double calculateTotalPrice() {
    double total = 0.0;
    for (CartModel product in dsHang) {
      total += double.parse(product.gia) * int.parse(product.soLuong);
    }
    total += shippingFee;

    return total;
  }

  double shippingFee = 30.0;

  @override
  void initState() {
    super.initState();
    getPre();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title:
              Text('Giỏ hàng', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: false,
          backgroundColor: Color.fromARGB(255, 136, 202, 191),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Menu(),
                ),
              );
            },
          ),
          actions: [
            IconButton(
              icon: Row(
                children: [
                  Icon(Icons.payment),
                  SizedBox(width: 5),
                  Text('Thanh toán',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              onPressed: () {
                if (dsHang.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddressScreen()),
                  );
                } else {
                  // Show Snackbar when the cart is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Giỏ hàng đang trống'),
                    ),
                  );
                }
              },
            ),
          ]),
      body: dsHang.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/giohang_rong.png',
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Giỏ hàng trống !',
                    style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 155, 155, 155)),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: dsHang.length,
                    itemBuilder: (context, index) {
                      final product = dsHang[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: ListTile(
                          title: Text(
                            product.tenTA,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                  '${double.parse(product.gia).toStringAsFixed(3)} VNĐ'),
                              SizedBox(width: 20),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        capNhatSoLuong(
                                            "kurang", product.maGioHang);
                                      });
                                    },
                                  ),
                                  Text(product.soLuong),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      capNhatSoLuong(
                                          "tambah", product.maGioHang);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                xoaGioHang(product.maGioHang);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text(
                          //   'Số lượng:',
                          //   style: TextStyle(
                          //       fontSize: 16, fontWeight: FontWeight.bold),
                          // ),
                          // Text(
                          //   '${dsHang.length}',
                          //   style: TextStyle(
                          //       fontSize: 16, fontWeight: FontWeight.bold),
                          // ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Phí vận chuyển:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' ${shippingFee.toStringAsFixed(3)} VNĐ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tổng tiền:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' ${calculateTotalPrice().toStringAsFixed(3)} VNĐ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {},
      //   label: Text('Thanh toán'),
      //   icon: Icon(Icons.shopping_cart_checkout_sharp),
      //   backgroundColor: Color.fromARGB(255, 208, 230, 255),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  TextEditingController _addressController = TextEditingController();

  TextEditingController _houseNumberController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? id, fullname, phone;
  getPre() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    setState(() {
      id = pre.getString(PrefProfile.id);
      fullname = pre.getString(PrefProfile.fullname);
      phone = pre.getString(PrefProfile.phone);
    });
    layHang();
  }

  @override
  void initState() {
    super.initState();
    getPre();
  }

  List<CartModel> dsHang = [];
  layHang() async {
    dsHang.clear();
    var urlLayHang = Uri.parse(BASEURL.apiGioHang + id.toString());
    final response = await http.get(urlLayHang);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map item in data) {
          dsHang.add(CartModel.fromJson(item));
        }
      });
    }
  }

  double calculateTotalPrice() {
    double total = 0.0;
    for (CartModel product in dsHang) {
      total += double.parse(product.gia) * int.parse(product.soLuong);
    }
    total += shippingFee;

    return total;
  }

  double shippingFee = 30.0;

  thanhToan() async {
    var uriThanhToan = Uri.parse(BASEURL.apiThanhToan);
    final response = await http.post(uriThanhToan, body: {
      "id": id,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      print(message);
    } else {
      print(message);
    }
  }

  //final TextEditingController _houseNumberController = TextEditingController();
  String _selectedCountry = '';
  String _selectedProvince = '';
  String _selectedDistrict = '';
  String _selectedCommune = '';
  String selectedPaymentMethod = ''; // Track the selected payment method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Đơn hàng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 136, 202, 191),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thông tin liên hệ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tên:',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('Edit phone number');
                    },
                    child: Row(
                      children: [
                        Text(
                          '${fullname}         ',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        //]Icon(Icons.edit),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Số điện thoại: ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('Edit phone number');
                    },
                    child: Row(
                      children: [
                        Text(
                          '${phone}    ',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Icon(Icons.edit),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Địa chỉ:',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              TextFormField(
                controller: _houseNumberController,
                decoration: InputDecoration(
                  hintText: 'Nhập địa chỉ nhà của bạn',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập địa chỉ nhà của bạn';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              SizedBox(height: 25),
              Text(
                'Thông tin đơn hàng',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [],
              ),
              // SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Phí vận chuyển:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' ${shippingFee.toStringAsFixed(3)} VNĐ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tổng tiền:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' ${calculateTotalPrice().toStringAsFixed(3)} VNĐ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                'Phương thức thanh toán',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              buildPaymentMethodWidget('Thanh toán khi nhận hàng'),
              buildPaymentMethodWidget('Ví điện tử MoMo'),

              //SizedBox(height: 30),
              Row(
                children: [
                  Icon(
                    Icons.local_offer,
                    color: Colors.red,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Show a dialog or navigate to a new screen for entering the promotional code
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Nhập mã khuyến mãi'),
                                content: TextFormField(
                                  // You can customize the text field for entering the code
                                  decoration: InputDecoration(
                                      labelText: 'Mã khuyến mãi'),
                                  // Use the entered code as needed
                                  onChanged: (value) {
                                    // Handle the entered code
                                    print('Entered code: $value');
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Đóng'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // You can validate and apply the code here
                                      // For example, you can call a function like applyPromoCode(value)
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Áp dụng'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons
                                    .card_giftcard, // Choose an appropriate icon
                                color: Colors.black,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Voucher của cửa hàng',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (selectedPaymentMethod.isEmpty) {
                      // Show a warning if payment method is not selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Vui lòng chọn phương thức thanh toán.'),
                        ),
                      );
                    } else {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => dathangtc(),
                        ),
                      );
                      thanhToan();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 136, 202, 191),
                ),
                child: Container(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Đặt hàng',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPaymentMethodWidget(String paymentMethodName) {
    IconData paymentIcon;

    switch (paymentMethodName.toLowerCase()) {
      case 'thanh toán khi nhận hàng':
        paymentIcon = Icons.credit_card;
        break;
      case 'ví điện tử momo':
        paymentIcon = Icons.payment;
        break;
      default:
        paymentIcon = Icons.payment; // Default icon
    }

    return ListTile(
      title: Row(
        children: [
          Icon(paymentIcon, size: 24),
          SizedBox(width: 16),
          Text(
            paymentMethodName,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      leading: Radio(
        value: paymentMethodName,
        groupValue: selectedPaymentMethod,
        onChanged: (value) {
          setState(() {
            selectedPaymentMethod = value.toString();
          });
        },
      ),
      onTap: () {
        setState(() {
          selectedPaymentMethod = paymentMethodName;
        });
      },
    );
  }
}
