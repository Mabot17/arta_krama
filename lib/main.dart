import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'app.dart';
import 'routes/app_routes_constant.dart';
import 'package:arta_krama/modules/auth/login/controllers/auth_login_controller.dart';
import 'package:arta_krama/core/utils/storage_service.dart';
import 'package:arta_krama/core/utils/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();

  final storageService = StorageService();
  final dbHelper = DatabaseHelper();

  // Tentukan path database
  final docsDir = await getApplicationDocumentsDirectory();
  final dbPath = join(docsDir.path, 'arta_krama.db');

  // Simpan path ke storage jika belum ada
  final savedPath = await storageService.read('offline_db_path');
  if (savedPath == null) {
    await storageService.write('offline_db_path', dbPath);
  }

  // Inisialisasi database hanya jika belum pernah dilakukan
  final isDbInitialized = await storageService.read('is_db_initialized') ?? false;
  if (!isDbInitialized) {
    await dbHelper.openDatabaseFromPath(dbPath);
    await storageService.write('is_db_initialized', true);
  }

  await dbHelper.initDatabaseOffline();

  // Inisialisasi global controller
  Get.put(AuthController());

  // Tentukan initial route berdasarkan token
  final String? token = await storageService.read<String>('access_token');
  final bool isValidToken = token != null;

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => child!,
      child: MyApp(
        initialRoute: isValidToken
            ? AppRoutesConstants.home
            : AppRoutesConstants.login,
      ),
    ),
  );
}
