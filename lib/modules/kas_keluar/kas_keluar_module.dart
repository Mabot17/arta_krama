import 'package:get/get.dart';
import 'package:arta_krama/modules/kas_keluar/views/kas_keluar_view.dart';
import 'package:arta_krama/modules/kas_keluar/views/kas_keluar_form_isian_view.dart';
import 'package:arta_krama/modules/kas_keluar/controllers/kas_keluar_controller.dart';
import 'package:arta_krama/routes/app_routes_constant.dart';

class KasKeluarModule {
  static final routes = [
    GetPage(
      name: AppRoutesConstants.kasKeluar, // ← sesuaikan nama route
      page: () => KasKeluarView(),
      binding: BindingsBuilder(() {
        Get.put(KasKeluarController());
      }),
    ),
    GetPage(
      name: AppRoutesConstants.kasKeluarFormIsian,
      page: () => KasKeluarFormIsianView(), // ← form add/edit
    ),
  ];
}
