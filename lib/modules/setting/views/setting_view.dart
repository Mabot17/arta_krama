import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arta_krama/core/constant/colors_theme.dart';
import 'package:arta_krama/core/utils/layout_extension.dart';
import 'package:arta_krama/widgets/widget_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/setting_controller.dart'; // Import SettingController

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final SettingController _controller =
      SettingController(); // Inisialisasi SettingController

  @override
  void initState() {
    super.initState();
    initConstructor();
  }

  void initConstructor() {
    LayoutExtension.navigationColor(
      ColorsTheme.white,
      ColorsTheme.primaryDarkBrown,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: ColorsTheme.transparent),
      child: Container(
        color: ColorsTheme.grey10,
        child: Stack(
          children: [
            WidgetAppBar(title: "Setting"),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _settingButton(
                      icon:
                          Icons
                              .cloud_download_rounded, // Backup Database
                      title: "Backup Database",
                      color: ColorsTheme.primaryDarkBrown,
                      onTap: () {
                        _controller.backupDatabaseToDownload(); // Memanggil fungsi backup di controller
                      },
                    ),
                    SizedBox(height: 15.h),
                    _settingButton(
                      icon: Icons.restore_rounded, // Restore Database
                      title: "Restore Database",
                      color: ColorsTheme.textEndUser,
                      onTap: () async {
                        // Memanggil fungsi restore dari controller
                        _controller.restoreDatabaseFromLocal();
                        // ignore: avoid_print
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
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: ColorsTheme.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: ColorsTheme.grey40),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 26.sp),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorsTheme.black,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: ColorsTheme.grey40),
          ],
        ),
      ),
    );
  }
}
