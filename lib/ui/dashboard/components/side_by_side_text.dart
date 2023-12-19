import 'package:flutter/material.dart';

class SideBySideText extends StatelessWidget {

  final String label;
  final String value;

  const SideBySideText({
    super.key,
    required this.value,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black
          ),
        )
      ],
    );
  }
}
