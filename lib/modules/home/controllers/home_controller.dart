import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arta_krama/core/utils/storage_service.dart';
import 'package:arta_krama/routes/app_routes_constant.dart';
import 'package:arta_krama/core/constant/menu_config.dart';

class HomeController extends GetxController {
  final StorageService _storage = StorageService(); // Pakai StorageService

  var username = ''.obs;
  var menuData = <dynamic>[].obs;
  var currentIndex = 0.obs;

  // Keranjang: key = productId, value = map {product, qty}

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  Future<void> loadUserData() async {
    final userDataRaw = await _storage.read('user_data');

    Map<String, dynamic> userData;

    if (userDataRaw == null) {
      userData = {};
    } else if (userDataRaw is String) {
      // Kalau String, decode dulu
      userData = jsonDecode(userDataRaw);
    } else if (userDataRaw is Map<String, dynamic>) {
      // Kalau sudah Map, langsung pakai
      userData = userDataRaw;
    } else {
      userData = {};
    }

    username.value = userData['username'] ?? 'Unknown';  // Sesuaikan key username
    // print(menuJson);
    menuData.value = List<Map<String, dynamic>>.from(jsonDecode(menuJson)['sections']);
  }

  void logout() {
    _storage.clear();
    Get.offAllNamed(AppRoutesConstants.login);
  }

  void handleMenuTap(Map<String, dynamic> item) {
    print("✅ Click Menu :  ${item['route']}");

    if (item['route'] == null) {
      Get.snackbar(
        "Info",
        "Fitur belum tersedia",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      Get.toNamed(item['route']);
    } catch (e) {
      print("❌ Error navigating to ${item['route']}: $e");
      Get.toNamed(AppRoutesConstants.maintenance);
      Get.snackbar(
        "Error",
        "Halaman tidak ditemukan atau belum terdaftar.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
