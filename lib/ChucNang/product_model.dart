class Product {
  final String maTA;
  final String tenTA;
  final String gia;
  final String danhGia;
  final String mieuTa;
  String soLuong; // Added quantity property
  final String maLoaiTA;

  Product({
    required this.maTA,
    required this.tenTA,
    required this.gia,
    required this.danhGia,
    required this.mieuTa,
    required this.soLuong, // Default quantity is 1
    required this.maLoaiTA,
  });

  factory Product.fromJson(Map<String, dynamic> data) {
    return Product(
        maTA: data['maTA'],
        tenTA: data['tenTA'],
        gia: data['gia'],
        danhGia: data['danhGia'],
        mieuTa: data['mieuTa'],
        soLuong: data['soLuong'],
        maLoaiTA: data['maloaiTA']);
  }
}

class Category {
  final String maLoaiTA;
  final String hinhLoai;
  final String tenLoai;
  final List<Product> product;

  Category(
      {required this.maLoaiTA,
      required this.hinhLoai,
      required this.tenLoai,
      required this.product});

  factory Category.fromJson(Map<String, dynamic> data) {
    var list = data['thucAn'] as List;
    List<Product> listProduct = list.map((e) => Product.fromJson(e)).toList();
    return Category(
        maLoaiTA: data['maLoaiTA'],
        hinhLoai: data['hinhLoai'],
        tenLoai: data['tenLoai'],
        product: listProduct);
  }
}
