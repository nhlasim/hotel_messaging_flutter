import 'package:flutter/material.dart';
import 'package:hote_management/config/app_color.dart';

class CustomElevatedButton extends StatelessWidget {

  final String btnLabel;
  final Color? btnColor;
  final VoidCallback? onBtnPressed;
  final BorderRadiusGeometry? btnBorderRadius;
  final TextStyle? labletextstyle;
  final Color? borderColor;
  final double borderWidth;

  const CustomElevatedButton({
    super.key,
    required this.btnLabel,
    this.btnColor = AppColors.loginBtnColor,
    this.onBtnPressed,
    this.btnBorderRadius,
    this.labletextstyle,
    this.borderColor,
    this.borderWidth = 1
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onBtnPressed,
      style: ButtonStyle(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        tapTargetSize: MaterialTapTargetSize.padded,
        alignment: Alignment.center,
        animationDuration: const Duration(milliseconds: 800),
        backgroundColor: MaterialStateProperty.all(btnColor),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(0.0),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: btnBorderRadius ?? BorderRadius.zero
        )),
        side: MaterialStateProperty.all(BorderSide(
          color: borderColor ?? AppColors.inputBorderColor,
          width: borderWidth
        )),
        textStyle: MaterialStateProperty.all(const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ))
      ),
      child: Text(btnLabel,style: labletextstyle),
    );
  }
}
