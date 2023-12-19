import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'input_field_with_header.dart';

class DropDownWithInputField<T> extends StatelessWidget {

  final List<T> items;
  final T selectedItems;
  final TextEditingController editingController;
  final ValueChanged<T?> onItemSelect;
  final String headerLabel;
  final String inputHint;
  final TextInputType keyboardType;
  final Color borderColor;
  final bool isReadable;
  final Widget? suffixWidget;

  const DropDownWithInputField({
    super.key,
    required this.editingController,
    required this.items,
    required this.selectedItems,
    required this.onItemSelect,
    required this.headerLabel,
    required this.inputHint,
    this.keyboardType = TextInputType.none,
    this.borderColor = Colors.black,
    this.isReadable = false,
    this.suffixWidget
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          headerLabel,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12
          )
        ),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                shape: BoxShape.rectangle
              ),
              width: 20.w,
              height: 32.h,
              margin: EdgeInsets.only(top: 4.h),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  items: items.map((e) {
                    return DropdownMenuItem<T>(
                      value: e,
                      child: Center(
                        child: Text(
                          e.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (T? value) => onItemSelect(value),
                  value: selectedItems,
                  alignment: Alignment.center,
                  isExpanded: true,
                ),
              ),
            ),

            InputFieldWithHeader(
              borderRadius: BorderRadius.zero,
              editingController: editingController,
              headerLabel: '',
              hideHeader: true,
              inputHint: inputHint,
              isReadOnly: isReadable,
              inputType: keyboardType,
              inputAction: TextInputAction.next,
              borderSideColor: borderColor,
              suffixIcon: suffixWidget,
            )

          ],
        ),
      ],
    );
  }
}
