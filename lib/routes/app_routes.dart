import 'package:get/get.dart';
import 'package:arta_krama/modules/auth/login/auth_login_module.dart';
import 'package:arta_krama/modules/auth/register/auth_register_module.dart';
import 'package:arta_krama/modules/home/home_module.dart';
import 'package:arta_krama/modules/setting/setting_module.dart';
import 'package:arta_krama/modules/kas_masuk/kas_masuk_module.dart';
import 'package:arta_krama/modules/global/view/under_construction_view.dart';

class AppRoutes {
  static final routes = [
    // Pemanggilan Global langsung routes full
    ...HomeModule.routes,
    ...AuthLoginModule.routes,
    ...AuthRegisterModule.routes,
    ...SettingModule.routes,
    ...KasMasukModule.routes,
    ...SettingModule.routes,
    
    // Khusus maintenance pemanggilan berbeda karena hanya view saja
    GetPage(
      name: "/maintenance",
      page: () => UnderConstructionView(),
    ),
    GetPage(
      name: "/not_found",
      page: () => UnderConstructionView(),
    ),
  ];
}
