import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  static Future showToastMsg(String msg, {double? fontSize, Color? bgColor}) async {
    Fluttertoast.showToast(msg: msg, fontSize: fontSize ?? 18.h, backgroundColor: bgColor, gravity: ToastGravity.BOTTOM, webShowClose: true, textColor: Colors.white);
  }
}