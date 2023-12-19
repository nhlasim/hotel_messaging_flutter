import 'package:flutter/material.dart';
import 'package:hote_management/config/app_color.dart';

class CustomRadioButton<T> extends StatelessWidget {

  final T radioValue;
  final T? radioGroupValue;
  final ValueChanged<T?> onRadioValueChanged;
  final String data;

  const CustomRadioButton({
    super.key,
    required this.onRadioValueChanged,
    required this.radioGroupValue,
    required this.radioValue,
    required this.data
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        Radio<T>(
          value: radioValue,
          groupValue: radioGroupValue,
          onChanged: onRadioValueChanged,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          activeColor: AppColors.primaryColor,
          materialTapTargetSize: MaterialTapTargetSize.padded,
        ),

        Text(
          data,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        )

      ],
    );
  }
}
