class CartModel {
  final String maGioHang;
  String soLuong;
  final String tenTA;
  final String gia;

  CartModel({
    required this.maGioHang,
    required this.soLuong,
    required this.tenTA,
    required this.gia,
  });

  factory CartModel.fromJson(data) {
    return CartModel(
        maGioHang: data['maGioHang'], 
        soLuong: data['soLuong'],
        tenTA: data['tenTA'], 
        gia: data['gia'], 
        );
  }
}