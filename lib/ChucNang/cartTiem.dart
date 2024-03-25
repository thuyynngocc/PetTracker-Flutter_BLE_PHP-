import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class cartTiem extends StatelessWidget {
  final String maTiem;
  final String tenTiem;
  final DateTime ngay;
  final TimeOfDay gio;

  cartTiem({required this.maTiem, required this.tenTiem, required this.ngay,required this.gio}); //required this.gio

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(tenTiem),
        SizedBox(
          height: 10,
        ),
        Text(ngay.toString()), // Chuyển đổi ngày thành chuỗi để hiển thị .toString()
        Text(gio.format(context)), // Format thời gian theo định dạng của context
      ],
    );
  }
}
