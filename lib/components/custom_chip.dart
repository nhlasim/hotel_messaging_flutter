import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hote_management/config/app_color.dart';

class CustomChip<T> extends StatelessWidget {

  final List<T> items;
  final ValueChanged<T> onValueSelected;
  final double? sizePerItems;
  final T selectedItem;
  final Color? selectedItemColor;
  final BorderRadius? containerBorderRadius;
  final FontWeight chipTextFontWeight;
  final double? chipTextFontSize;
  final Color? containerBorderColor;

  const CustomChip({
    super.key,
    required this.items,
    required this.onValueSelected,
    this.sizePerItems,
    required this.selectedItem,
    this.selectedItemColor,
    this.containerBorderRadius,
    this.chipTextFontSize,
    this.chipTextFontWeight = FontWeight.w600,
    this.containerBorderColor
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: items.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final itemData = items[index] as String;
        return GestureDetector(
          onTap: () => onValueSelected(itemData as T),
          child: Container(
            width: sizePerItems ?? 32.w,
            height: 10.h,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: containerBorderRadius,
              color: selectedItem == itemData
              ? selectedItemColor ?? AppColors.homeChipColor
              : null,
              border: Border.all(color: containerBorderColor ?? Colors.grey.shade400),
            ),
            alignment: Alignment.center,
            child: Text(
              itemData,
              style: TextStyle(
                color: selectedItem == itemData
                ? Colors.white
                : null,
                fontWeight: chipTextFontWeight,
                fontSize: chipTextFontSize ?? 4.w
              ),
            ),
          ),
        );
      },
    );
  }
}
