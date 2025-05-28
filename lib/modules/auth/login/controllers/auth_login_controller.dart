import 'package:get/get.dart';
import 'package:arta_krama/modules/auth/login/services/auth_login_service.dart';
import 'package:arta_krama/routes/app_routes_constant.dart';
import 'package:arta_krama/widgets/widget_snackbar.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  final AuthLoginService _authService = AuthLoginService();

  // Untuk login
  void login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      WidgetSnackbar.danger("Error", "Username dan password wajib diisi");
      return;
    }

    bool success = await _authService.login(username, password);
    if (success) {
      isLoggedIn.value = true;
      Get.offAllNamed(AppRoutesConstants.home);
    } else {
      WidgetSnackbar.danger("Login Gagal", "Periksa kembali kredensial Anda");
    }
  }

  // Untuk register
  void register(Map<String, dynamic> userData) async {
    print(userData);
    if ((userData['username'] == null || userData['username'].toString().trim().isEmpty) ||
        (userData['password'] == null || userData['password'].toString().trim().isEmpty)) {
      WidgetSnackbar.danger("Error", "Username dan password wajib diisi");
      return;
    }

    bool success = await _authService.register(userData);
    if (success) {
      WidgetSnackbar.success("Berhasil", "Registrasi berhasil, silakan login");
      Get.offAllNamed(AppRoutesConstants.login);
    } else {
      WidgetSnackbar.danger("Gagal", "Username sudah digunakan atau error lain");
    }
  }

  // Untuk logout
  void logout() {
    _authService.logout();
    isLoggedIn.value = false;
    Get.offAllNamed(AppRoutesConstants.login);
  }

  // Cek status saat controller diinisialisasi
  @override
  void onInit() {
    isLoggedIn.value = _authService.isLoggedIn();
    super.onInit();
  }

  void handleMenuLoginTap(Map<String, dynamic> item) {
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
