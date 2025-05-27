import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetSnackbar {
  static void success(String title, String message) {
    _showSnackbar(title, message, Colors.green, Icons.check_circle);
  }

  static void primary(String title, String message) {
    _showSnackbar(title, message, Colors.blue, Icons.info);
  }

  static void danger(String title, String message) {
    _showSnackbar(title, message, Colors.red, Icons.error);
  }

  static void info(String title, String message) {
    _showSnackbar(title, message, Colors.teal, Icons.info_outline);
  }

  static void warning(String title, String message) {
    _showSnackbar(title, message, Colors.orange, Icons.warning);
  }

  static void _showSnackbar(String title, String message, Color color, IconData icon) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      icon: Icon(icon, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }
}
