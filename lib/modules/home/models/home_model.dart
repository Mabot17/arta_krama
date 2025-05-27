import 'package:flutter/material.dart';

class HomeModel {
 static IconData getIconData(String iconName) {
    switch (iconName) {
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'money_off':
        return Icons.money_off;
      case 'assessment':
        return Icons.assessment;
      case 'dashboard':
        return Icons.dashboard;
      case 'show_chart':
        return Icons.show_chart;
      case 'date_range':
        return Icons.date_range;
      default:
        return Icons.help_outline; // default icon kalau tidak ditemukan
    }
  }
}
