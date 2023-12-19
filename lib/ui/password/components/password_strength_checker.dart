import 'package:flutter/material.dart';

class PasswordStrengthChecker extends StatefulWidget {
  
  const PasswordStrengthChecker({
    super.key,
    required this.password,
    required this.onStrengthChanged,
  });

  final String password;

  final Function(bool isStrong) onStrengthChanged;

  @override
  State<PasswordStrengthChecker> createState() => _PasswordStrengthCheckerState();

}

class _PasswordStrengthCheckerState extends State<PasswordStrengthChecker> {
  
  @override
  void didUpdateWidget(covariant PasswordStrengthChecker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.password != oldWidget.password) {
      final isStrong = _validators.entries.every((entry) => entry.key.hasMatch(widget.password));
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.onStrengthChanged(isStrong),
      );
    }
  }

  final Map<RegExp, String> _validators = {
    RegExp(r'[A-Z]'): 'One uppercase letter',
    RegExp(r'[a-z]'): 'One lowercase letter',
    RegExp(r'[!@#\$%^&*(),.?":{}|<>]'): 'One special character',
    RegExp(r'\d'): 'One number',
    RegExp(r'^.{8,32}$'): '8-32 characters',
  };

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.password.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _validators.entries.map((entry) {
          final hasMatch = entry.key.hasMatch(widget.password);

          final color = hasValue ? (hasMatch ? Colors.green : Colors.red) : null;

          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              entry.value,
              style: TextStyle(color: color),
            ),
          );
        },
      ).toList(),
    );
  }
}