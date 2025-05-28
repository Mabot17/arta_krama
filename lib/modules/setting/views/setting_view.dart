import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arta_krama/modules/setting/controllers/setting_controller.dart';
import 'package:arta_krama/widgets/widget_appbar.dart';

class SettingView extends StatelessWidget {
  final SettingController _controller = Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const WidgetAppBar(title: "Setting"),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _settingButton(
                      icon: Icons.cloud_download_rounded,
                      title: "Backup Database",
                      color: Color(0xFF1E90FF), // Biru
                      onTap: () {
                        _controller.backupDatabaseToDownload();
                      },
                    ),
                    SizedBox(height: 15.h),
                    _settingButton(
                      icon: Icons.restore_rounded,
                      title: "Restore Database",
                      color: Color(0xFFFF8C00), // Oranye
                      onTap: () {
                        _controller.restoreDatabaseFromLocal();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(title, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }
}
