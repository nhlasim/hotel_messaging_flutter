import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/app_assets.dart';

class AttachmentView extends StatelessWidget {

  final VoidCallback onClick;

  const AttachmentView({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [

          Image.asset(
            AppAssets.attachment,
            height: 5.w,
            width: 5.w,
          ),

          SizedBox(width: 2.w,),

          Text(
            'Attach File',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600
            ),
          ),

        ],
      ),
    );
  }
}
