import 'package:get/get.dart';
import 'package:arta_krama/modules/auth/register/views/auth_register_view.dart';
import 'package:arta_krama/modules/auth/login/controllers/auth_login_controller.dart';
import '../../../routes/app_routes_constant.dart'; // Import konstanta

class AuthRegisterModule {
  static final routes = [
    GetPage(
      name: AppRoutesConstants.register,
      page: () => RegisterView(),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    ),
  ];
}

