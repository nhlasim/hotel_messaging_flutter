import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatItemView extends StatelessWidget {

  final Color containerColor;
  final String messageBody;
  final String messageDate;
  final String type;
  final String? serverStaticRobotMenu;

  const ChatItemView({
    super.key,
    required this.messageBody,
    required this.containerColor,
    required this.messageDate,
    required this.type,
    this.serverStaticRobotMenu
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          constraints: BoxConstraints(maxWidth: 50.sw),
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: containerColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2.w)
          ),
          child: Text.rich(
            TextSpan(
              text: type,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(
                  text: messageBody,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 12
                  )
                )
              ]
            )
          ),
        ),

        SizedBox(height: 4.h,),

        Text(
          messageDate,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Colors.black54,
          ),
        )

      ],
    );
  }
}
