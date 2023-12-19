import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hote_management/config/app_color.dart';

class HeaderWithInput extends StatelessWidget {

  final TextEditingController editingController;
  final String header;
  final TextInputType? inputType;
  final TextCapitalization capitalization;
  final TextInputAction? inputAction;
  final ValueChanged<String>? onValueSubmitted;
  final bool shouldObscureText;
  final VoidCallback? onObscureChange;

  const HeaderWithInput({
    super.key,
    required this.editingController,
    required this.header,
    this.inputType,
    this.capitalization = TextCapitalization.none,
    this.inputAction,
    this.onValueSubmitted,
    this.shouldObscureText = false,
    this.onObscureChange
  });

  @override
  Widget build(BuildContext context) {
    if (shouldObscureText && onObscureChange == null) {
      throw Exception('onObscureChange should not be null.');
    }
    const outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: AppColors.inputBorderColor)
    );

    final inputDecoration = InputDecoration(
      border: outlineInputBorder,
      alignLabelWithHint: true,
      suffixIcon: inputType == TextInputType.visiblePassword
      ? IconButton(
        onPressed: () => onObscureChange!(),
        icon: Icon(shouldObscureText ? Icons.visibility_rounded : Icons.visibility_off_rounded),
        color: AppColors.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        alignment: Alignment.center,
      )
      : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
      disabledBorder: outlineInputBorder,
      enabled: true,
      enabledBorder: outlineInputBorder,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      focusedBorder: outlineInputBorder,
      // suffix: inputType == TextInputType.visiblePassword
      // ? IconButton(
      //   onPressed: () => onObscureChange!(),
      //   icon: Icon(shouldObscureText ? Icons.visibility_rounded : Icons.visibility_off_rounded),
      // )
      // : null
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          header,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: AppColors.inputBorderColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
          ),
        ),

        SizedBox(height: 10.h,),

        TextField(
          controller: editingController,
          decoration: inputDecoration,
          autocorrect: true,
          cursorColor: AppColors.primaryColor,
          textAlign: TextAlign.start,
          enabled: true,
          onSubmitted: onValueSubmitted,
          obscureText: shouldObscureText,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          keyboardType: inputType,
          textCapitalization: capitalization,
          textInputAction: inputAction,
        ),

      ],
    );
  }
}
