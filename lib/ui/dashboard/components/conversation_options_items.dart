import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConversationOptionsItem<T> extends StatelessWidget {

  final String assetName;
  final String e;
  final List<PopupMenuItem<T>> items;
  final double? width;
  final bool usePopupMenuButtonAsTopLevel;
  final VoidCallback? onCustomPressed;

  const ConversationOptionsItem({
    super.key,
    required this.assetName,
    required this.e,
    required this.items,
    this.width,
    this.usePopupMenuButtonAsTopLevel = true,
    this.onCustomPressed
  });

  @override
  Widget build(BuildContext context) {
    if (usePopupMenuButtonAsTopLevel) {
      return PopupMenuButton<T>(
        itemBuilder: (context) => items,
        padding: EdgeInsets.zero,
        tooltip: e,
        constraints: BoxConstraints(minWidth: width ?? 0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.w)
        ),
        position: PopupMenuPosition.under,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 6.h),
          child: innerChild(),
        ),
      );
    }
    return GestureDetector(
      onTap: onCustomPressed,
      child: innerChild(),
    );
  }

  Widget innerChild() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [

        Image.asset(
          assetName,
          height: 6.w,
          width: 6.w,
        ),

        SizedBox(width: 4.w,),

        Text(
          e,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.w400
          ),
        ),

        SizedBox(width: 2.w,),

        Icon(
          Icons.arrow_drop_down_rounded,
          color: Colors.black,
          size: 8.w,
        )

      ],
    );
  }
}


