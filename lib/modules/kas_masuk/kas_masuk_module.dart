import 'package:get/get.dart';
import 'package:arta_krama/modules/kas_masuk/views/kas_masuk_view.dart';
import 'package:arta_krama/modules/kas_masuk/views/kas_masuk_form_view.dart';
import 'package:arta_krama/modules/kas_masuk/controllers/kas_masuk_controller.dart';
import 'package:arta_krama/routes/app_routes_constant.dart';

class KasMasukModule {
  static final routes = [
    GetPage(
      name: AppRoutesConstants.kasMasuk, // ← sesuaikan nama route
      page: () => KasMasukView(),
      binding: BindingsBuilder(() {
        Get.put(KasMasukController());
      }),
    ),
    GetPage(
      name: AppRoutesConstants.kasMasukForm,
      page: () => KasMasukFormView(), // ← form add/edit
    ),
  ];
}
