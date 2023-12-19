import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputFieldWithHeader extends StatelessWidget {

  final TextEditingController editingController;
  final String headerLabel;
  final String inputHint;
  final BorderRadius? borderRadius;
  final Color? borderSideColor;
  final TextInputType? inputType;
  final TextCapitalization capitalization;
  final TextInputAction? inputAction;
  final int? maximumLength;
  final int? maximumLines;
  final bool useInfinityWidth;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isReadOnly;
  final ValueChanged<DateTime>? onDateSelected;
  final double? inputFieldWidth;
  final TextAlign textAlignment;
  final bool hideHeader;
  final TextStyle? hintStyle;

  const InputFieldWithHeader({
    super.key,
    required this.editingController,
    required this.headerLabel,
    required this.inputHint,
    this.borderRadius,
    this.borderSideColor,
    this.capitalization = TextCapitalization.none,
    this.inputType,
    this.inputAction,
    this.maximumLength,
    this.maximumLines,
    this.prefixIcon,
    this.suffixIcon,
    this.useInfinityWidth = false,
    this.isReadOnly = false,
    this.onDateSelected,
    this.inputFieldWidth,
    this.textAlignment = TextAlign.start,
    this.hideHeader = false,
    this.hintStyle
  });

  @override
  Widget build(BuildContext context) {
    final outlineBorder = OutlineInputBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(4.0),
      borderSide: BorderSide(color: borderSideColor ?? Colors.grey.shade400)
    );

    Widget? suffixIcon;
    if (isReadOnly && onDateSelected != null) {
      suffixIcon = Icon(
        Icons.calendar_month_rounded,
        color: borderSideColor ?? Colors.grey.shade400,
        size: 4.w,
      );
    }
    return SizedBox(
      width: useInfinityWidth ? double.infinity : inputFieldWidth ?? 80.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          if (!hideHeader)
            Text(
                headerLabel,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                )
            ),

          SizedBox(height: 4.h),

          TextField(
            controller: editingController,
            decoration: InputDecoration(
              border: outlineBorder,
              enabled: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
              alignLabelWithHint: true,
              enabledBorder: outlineBorder,
              focusedBorder: outlineBorder,
              isDense: true,
              counterText: '',
              hintText: inputHint,
              hintStyle: hintStyle ?? const TextStyle(fontSize: 12.0, color: Color.fromRGBO(191, 191, 191, 1)),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon
            ),
            enabled: true,
            onTap: () {
              if (isReadOnly && onDateSelected != null) {
                _onDatePicker(context);
              }
            },
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.0
            ),
            readOnly: isReadOnly,
            textAlign: textAlignment,
            autocorrect: true,
            enableIMEPersonalizedLearning: true,
            enableInteractiveSelection: true,
            enableSuggestions: true,
            keyboardType: inputType,
            textCapitalization: capitalization,
            textInputAction: inputAction,
            maxLength: maximumLength,
            maxLines: maximumLines,
          ),
        ],
      ),
    );
  }

  Future _onDatePicker(BuildContext context) async {
    final newDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year + 1)
    );
    if (newDateTime != null) {
      if (onDateSelected != null) {
        onDateSelected!(newDateTime);
      }
    }
  }
}
