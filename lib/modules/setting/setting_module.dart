import 'package:get/get.dart';
import 'views/setting_view.dart';
import 'controllers/setting_controller.dart';
import '../../../routes/app_routes_constant.dart'; // Import konstanta

class SettingModule {
  static final routes = [
    GetPage(
      name: AppRoutesConstants.setting,
      page: () => SettingView(),
      binding: BindingsBuilder(() {
        Get.put(SettingController());
      }),
    ),
  ];
}
