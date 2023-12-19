import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorMsgDialog extends StatelessWidget {

  final String errorMsg;

  const ErrorMsgDialog({super.key, required this.errorMsg});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      title: const Text('Error'),
      elevation: 8.0,
      content: Text(
          errorMsg,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 16.h,
          fontWeight: FontWeight.w400,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.w)
      ),
      actions: [
        TextButton(
          child: const Text('Ok'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}
