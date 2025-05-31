import 'package:get/get.dart';
import 'package:arta_krama/modules/laporan/arus_kas/views/laporan_arus_kas_view.dart';
import 'package:arta_krama/modules/laporan/arus_kas/controllers/laporan_arus_kas_controller.dart';
import 'package:arta_krama/routes/app_routes_constant.dart';

class ArusKasModule {
  static final routes = [
    GetPage(
      name: AppRoutesConstants.arusKas, // ← sesuaikan nama route
      page: () => ArusKasView(),
      binding: BindingsBuilder(() {
        Get.put(ArusKasController());
      }),
    ),
  ];
}
