import 'package:flutter/cupertino.dart';

class cartLoai extends StatelessWidget {
  final String hinhLoai;
  final String tenLoai;

  cartLoai({required this.hinhLoai, required this.tenLoai});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        Image.asset(
          hinhLoai,
          width: 170,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          tenLoai,
          style: TextStyle(fontSize: 18,          fontWeight:FontWeight.bold,
),
        )
      ],
    );
  }
}
