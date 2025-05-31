import 'package:get/get.dart';
import 'package:arta_krama/modules/laporan/dashboard/views/laporan_dashboard_view.dart';
import 'package:arta_krama/modules/laporan/dashboard/controllers/laporan_dashboard_controller.dart';
import 'package:arta_krama/routes/app_routes_constant.dart';

class DashboardModule {
  static final routes = [
    GetPage(
      name: AppRoutesConstants.dashboard, // ← sesuaikan nama route
      page: () => DashboardView(),
      binding: BindingsBuilder(() {
        Get.put(DashboardController());
      }),
    ),
  ];
}
