import 'package:flutter/material.dart';

class DSTiem {
  String maTiem;
  String tenTiem;
  //DateTime ngayTiem;
  //String userID;
  String ngay;
  String gio;

  DSTiem({
    required this.maTiem,
    required this.tenTiem,
    //required this.ngayTiem,
    //required this.userID,
    required this.ngay,
    required this.gio,
  });
  factory DSTiem.fromJson(json) {
    return DSTiem(
      maTiem: json['maTiem'],
      tenTiem: json['tenTiem'],
      ngay: json['ngayTiem'],
      //userID: data['userID'],
      gio: json['gioTiem'],
    );
  }
}

