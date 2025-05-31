import 'package:flutter/material.dart';

class WidgetTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboard;
  final Color color;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;

  const WidgetTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.color,
    this.isPassword = false,
    this.keyboard = TextInputType.text,
    this.validator,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboard,
        validator: validator,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: color),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color, width: 2),
          ),
        ),
      ),
    );
  }
}
