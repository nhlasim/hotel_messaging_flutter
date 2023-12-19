import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomHeaderWithText extends StatelessWidget {

  final String label;
  final String value;

  const CustomHeaderWithText({
    super.key,
    required this.label,
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600
            ),
          ),
    
          SizedBox(height: 12.h,),
    
          Text(
            value,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w600
            ),
          ),
    
        ],
      ),
    );
  }
}