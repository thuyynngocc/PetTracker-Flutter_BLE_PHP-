import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thuyngoc/ChucNang/cartLoaiTA.dart';
import 'package:thuyngoc/ChucNang/giohang.dart';
import 'package:thuyngoc/ChucNang/product_model.dart';
import 'package:thuyngoc/network/api/url_api.dart';
import 'package:thuyngoc/network/model/pref_profile_model.dart';

class an extends StatefulWidget {
  const an({Key? key}) : super(key: key);
  @override
  _anState createState() => _anState();
}

class _anState extends State<an> {
  bool loading = true;
  Widget? loadingWidget;
  //late int index;
  int index = 0; // Default tab index

  bool filter = false;
  List<Category> dsloai = [];

  layLoaiTA() async {
    dsloai.clear();
    var url = Uri.parse(BASEURL.apiThucAnLoai);
    final reponse = await http.get(url);
    if (reponse.statusCode == 200) {
      setState(() {
        final data = jsonDecode(reponse.body);
        for (Map<String, dynamic> item in data) {
          dsloai.add(Category.fromJson(item));
        }
      });
      LayTA();
      demGioHang();
    }
  }

  List<Product> listProduct = [];
  LayTA() async {
    listProduct.clear();
    var url = Uri.parse(BASEURL.apiThucAn);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (Map<String, dynamic> product in data) {
          listProduct.add(Product.fromJson(product));
        }
      });
    }
  }

  String? id;
  getPref() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    setState(() {
      id = pre.getString(PrefProfile.id);
    });
  }

  var tongGioHang = "0";
  demGioHang() async {
    var urlDemGioHang = Uri.parse(BASEURL.apiDemGioHang + id.toString());
    final response = await http.get(urlDemGioHang);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      String tong = data['dem'];
      setState(() {
        tongGioHang = tong;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
    layLoaiTA();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 136, 202, 191),
        title: SizedBox(
          child: Image.asset(
            "assets/an.png",
            width: 73,
            height: 70,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  size: 30,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GioHang(demGioHang),
                    ),
                  );
                },
              ),
              tongGioHang == "0"
                  ? SizedBox()
                  : Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        height: 13,
                        width: 13,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: Text(
                            tongGioHang,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DefaultTabController(
              length: 3,
              initialIndex: index,
              child: Column(
                children: [
                  TabBar(
                    indicatorColor: Color.fromARGB(
                        255, 136, 202, 191), // Change the indicator color
                    labelColor: Color.fromARGB(255, 136, 202,
                        191), // Change the selected tab text color
                    unselectedLabelColor:
                        Colors.black, // Change the unselected tab text color
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.store,
                                color: Colors.black), // Change the icon color
                            SizedBox(width: 8),
                            Text('Cửa hàng'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.category,
                                color: Colors.black), // Change the icon color
                            SizedBox(width: 8),
                            Text('Danh mục'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_bag,
                                color: Colors.black), // Change the icon color
                            SizedBox(width: 8),
                            Text('Sản phẩm'),
                          ],
                        ),
                      ),
                    ],
                    onTap: (tabIndex) {
                      setState(() {
                        index = tabIndex;
                        filter = false;
                      });
                    },
                  ),
                  IndexedStack(
                    index: index,
                    children: [
                      buildCuaHangTabContent(),
                      buildDanhMucTabContent(),
                      buildSanPhamTabContent(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCuaHangTabContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage('assets/shop_banner.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Pet Tracker',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Địa chỉ: 123 Pet Street, Pet City',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Giới thiệu:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Chào mừng bạn đến với Pet Tracker! Chúng tôi cung cấp đầy đủ các sản phẩm và dịch vụ dành cho thú cưng của bạn. '
            'Tại Pet Tracker, chúng tôi cam kết mang lại cho bạn và thú cưng những trải nghiệm tuyệt vời nhất. Hãy đến và khám phá!',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Dịch vụ chính:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: () {
              // Handle service onTap
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color.fromARGB(255, 200, 227, 223),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.pets),
                  SizedBox(width: 16),
                  Text('Thức ăn chất lượng cho thú cưng'),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: () {
              // Handle service onTap
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color.fromARGB(255, 200, 227, 223),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.toys),
                  SizedBox(width: 16),
                  Text('Đồ chơi và đồ dùng cho thú cưng'),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: () {
              // Handle service onTap
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color.fromARGB(255, 200, 227, 223),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.medical_services),
                  SizedBox(width: 16),
                  Text('Dịch vụ y tế và chăm sóc sức khỏe'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDanhMucTabContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  dsloai.length,
                  (i) {
                    final x = dsloai[i];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          index = i;
                          filter = true;
                          print(
                              "Filtering: $filter, Index: $index, Product Count: ${dsloai[index].product.length}");
                        });
                      },
                      child: Container(
                        width: 170,
                        margin: EdgeInsets.only(
                            right: 16), // Adjust spacing as needed
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: filter && index == i
                              ? Color.fromARGB(255, 185, 217, 212)
                              : Colors.white,
                        ),
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.category,
                              color: filter && index == i
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              x.tenLoai,
                              style: TextStyle(
                                color: filter && index == i
                                    ? Colors.black
                                    : Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              filter ? 'Các sản phẩm đã chọn theo loài' : 'Tất cả sản phẩm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16),
          // Use filter to decide which products to display
          GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount:
                filter ? dsloai[index].product.length : listProduct.length,
            itemBuilder: (context, i) {
              if ((filter && dsloai[index].product.isEmpty) ||
                  (!filter && listProduct.isEmpty)) {
                return _buildEmptyProductWidget();
              }

              final product =
                  filter ? dsloai[index].product[i] : listProduct[i];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: product),
                    ),
                  );
                },
                child: Card(
                  color: Color.fromARGB(255, 224, 241, 234),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.tenTA,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${double.parse(product.gia).toStringAsFixed(3)} VNĐ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    Text(
                                      ' ${product.danhGia}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 24,
                            ),
                            Image.asset(
                              'assets/an.png',
                              height: 170,
                              width: 170,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyProductWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning, size: 50, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            'Hiện tại không có sản phẩm',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
Widget buildSanPhamTabContent() {
  return SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Các sản phẩm bán chạy',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 24,
            crossAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: listProduct.length,
          itemBuilder: (context, i) {
            final x = listProduct[i];
            return Card(
              color: Color.fromARGB(255, 224, 241, 234),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          x.tenTA,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${double.parse(x.gia).toStringAsFixed(3)} VNĐ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                Text(
                                  ' ${x.danhGia}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 24,
                        ),
                        Image.asset(
                          'assets/an.png',
                          height: 170,
                          width: 170,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}
}
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 20,
//             ),
//             Text(
//               'Chọn thức ăn theo loài',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             GridView.builder(
//                 itemCount: dsloai.length,
//                 shrinkWrap: true,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2),
//                 itemBuilder: (context, i) {
//                   final x = dsloai[i];
//                   return InkWell(
//                     onTap: () {
//                       setState(() {
//                         index = i;
//                         filter = true;
//                         print("$index, $filter");
//                       });
//                     },
//                     child: cartLoai(hinhLoai: x.hinhLoai, tenLoai: x.tenLoai),
//                   );
//                 }),
//             Padding(
//               padding: const EdgeInsets.all(1),
//               child: Text(
//                 'Các sản phẩm bán chạy',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             filter
//                 ? GridView.builder(padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 24,
//                       crossAxisSpacing: 16,
//                       childAspectRatio: 0.7,
//                     ),
//                     itemCount: dsloai[index].product.length,
//                     itemBuilder: (context, i) {
//                       final y = dsloai[index].product[i];
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     ProductDetailPage(product: y),
//                               ));
//                         },
//                         child: ShoeWidget(
//                           productName: y.tenTA,
//                           price: double.parse(y.gia),
//                           rating: y.danhGia,
//                         ),
//                       );
//                     },
//                   )
//                 : GridView.builder(
//                     padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 24,
//                       crossAxisSpacing: 16,
//                       childAspectRatio: 0.7,
//                     ),
//                     itemCount: listProduct.length,
//                     itemBuilder: (context, i) {
//                       final x = listProduct[i];
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     ProductDetailPage(product: x),
//                               ));
//                         },
//                         child: ShoeWidget(
//                           productName: x.tenTA,
//                           price: double.parse(x.gia),
//                           rating: x.danhGia,
//                         ),
//                       );
//                     },
//                   )
//           ],
//         ),
//       ),
//     );
//   }
// }

class ShoeWidget extends StatelessWidget {
  final String productName;
  final double price;
  final String rating;

  ShoeWidget({
    required this.productName,
    required this.price,
    required this.rating,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color.fromARGB(255, 208, 230, 255),
            ),
            child: Image.asset(
              "assets/an.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Text(
              "${price.toStringAsFixed(3)} VNĐ",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.red.shade300,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.star,
              color: Colors.red.shade300,
            ),
            Text(
              rating.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          productName,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  final Product product;
  ProductDetailPage({required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1; // Default quantity is 1
  List<Product> shoppingCart = []; // Khởi tạo shoppingCart ở đây
  String? id;
  getPref() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    setState(() {
      id = pre.getString(PrefProfile.id);
    });
  }

  void themGioHang() async {
    var urlThemGioHang = Uri.parse(BASEURL.apiThemGioHang);
    final response = await http.post(urlThemGioHang, body: {
      "id": id,
      "maTA": widget.product.maTA,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];

    if (value == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message ?? "Đã thêm vào giỏ hàng"),
        ),
      );

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
      });

      setState(() {});
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Thông báo"),
          content: Text(message ?? "Có lỗi xảy ra"),
          actions: [
            TextButton(
              onPressed: () {
                //Navigator.pop(context); // Close the AlertDialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GioHang(() {})),
                );
              },
              child: Text("Đồng ý"),
            ),
          ],
        ),
      );

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết sản phẩm',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 136, 202, 191),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/an.png',
                width: 250,
                height: 250,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.product.tenTA,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.star,
                  color: Colors.red,
                ),
                Text(
                  widget.product.danhGia.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              '${double.parse(widget.product.gia).toStringAsFixed(3)} VNĐ',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.product.mieuTa,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              themGioHang();
            },
            label: Text('Thêm vào giỏ hàng'),
            icon: Icon(Icons.shopping_cart_checkout_rounded),
            backgroundColor: Color.fromARGB(255, 136, 202, 191),
          )
        ],
      ),
    );
  }
}
