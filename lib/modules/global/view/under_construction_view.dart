import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constant/colors_theme.dart';
import '../../../core/constant/font_themes.dart';

class UnderConstructionView extends StatelessWidget {
  const UnderConstructionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ColorsTheme.white
        ),
        backgroundColor: ColorsTheme.primaryDarkBrown,
        title: Text(
          "Proses Pengerjaan",
          style: FontThemes.fontSize12wBold(
            color: ColorsTheme.white
          )
        ),
      ),
      body: Center(
        child: SvgPicture.asset(
          "assets/icon/under_construction.svg"
        ),
      )
    );
  }
}