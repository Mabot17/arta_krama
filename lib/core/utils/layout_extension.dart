import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // untuk SystemChrome dan rootBundle
import 'dart:convert'; // untuk json.decode
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/colors_theme.dart';
import '../constant/font_themes.dart';

class LayoutExtension {
  //DECORATION STYLE
  static ShapeBorder? buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50.r),
  );

  static ShapeBorder? buttonShapeBorder(Color? color) => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.r),
        side: BorderSide(width: 2.0.w, color: color!),
      );

  static ShapeBorder? boxShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.r),
  );

  static ShapeBorder? customBoxRadius(double radius) => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.r),
      );

  static ShapeBorder? boxWithStroke(double? radius, Color? color) =>
      RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius!.r),
          side: BorderSide(color: color!, width: 1.0.w));

  static ShapeBorder? halfBoxShape(String? status) {
    BorderRadius? topRadius = BorderRadius.only(
      topLeft: Radius.circular(10.r),
      topRight: Radius.circular(10.r),
    );

    BorderRadius? leftRadius = BorderRadius.only(
      topLeft: Radius.circular(10.r),
      bottomLeft: Radius.circular(10.r),
    );

    BorderRadius? rightRadius = BorderRadius.only(
      topRight: Radius.circular(10.r),
      bottomRight: Radius.circular(10.r),
    );

    return RoundedRectangleBorder(
        borderRadius: status == "top"
            ? topRadius
            : status == "left"
                ? leftRadius
                : rightRadius);
  }

  static BoxDecoration? halfBoxDecoClickable(String? status, bool? isClick) {
    BorderRadius? topRadius = BorderRadius.only(
      topLeft: Radius.circular(10.r),
      topRight: Radius.circular(10.r),
    );

    BorderRadius? leftRadius = BorderRadius.only(
      topLeft: Radius.circular(10.r),
      bottomLeft: Radius.circular(10.r),
    );

    BorderRadius? rightRadius = BorderRadius.only(
      topRight: Radius.circular(10.r),
      bottomRight: Radius.circular(10.r),
    );

    return BoxDecoration(
        color: isClick! ? ColorsTheme.primaryYellow : ColorsTheme.grey20,
        borderRadius: status == "top"
            ? topRadius
            : status == "left"
                ? leftRadius
                : rightRadius);
  }

  static BoxDecoration? diagonalSide(String? status) {
    BorderRadius? radiusSide() => status == "diagonal1"
        ? BorderRadius.only(
            topLeft: Radius.circular(8.r), bottomRight: Radius.circular(8.r))
        : BorderRadius.only(
            topRight: Radius.circular(8.r), bottomLeft: Radius.circular(8.r));

    return BoxDecoration(color: ColorsTheme.white, borderRadius: radiusSide());
  }

  static BoxDecoration? boxDeco(Color? colors) => BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: colors,
      );

  static BoxDecoration? halfSideBoxCustom(
      String? status, double? radius, Color? colorstheme) {
    BorderRadius leftSide = BorderRadius.only(
      topLeft: Radius.circular(radius!.r),
      bottomLeft: Radius.circular(radius.r),
    );

    BorderRadius topSide = BorderRadius.only(
      topLeft: Radius.circular(radius.r),
      topRight: Radius.circular(radius.r),
    );

    BorderRadius rightSide = BorderRadius.only(
      topRight: Radius.circular(radius.r),
      bottomRight: Radius.circular(radius.r),
    );

    BorderRadius bottomSide = BorderRadius.only(
      bottomRight: Radius.circular(radius.r),
      bottomLeft: Radius.circular(radius.r),
    );

    return BoxDecoration(
      color: colorstheme!,
      borderRadius: status == "left"
          ? leftSide
          : status == "top"
              ? topSide
              : status == "right"
                  ? rightSide
                  : bottomSide,
    );
  }

  static BorderRadius? borderRadius(double? radius) =>
      BorderRadius.circular(radius!.r);

  static InputDecoration inputformDecorationStyle(
      {required String hint,
      required bool? isNeedSuffixIcon,
      required bool? isFormContent,
      Function()? callback,
      String? helperText,
      IconData? icon}) {
    UnderlineInputBorder uib(bool? isFocused) => UnderlineInputBorder(
        borderSide: BorderSide(
            color: isFocused! ? ColorsTheme.primaryBrown : ColorsTheme.grey40,
            width: 1.w));

    InkWell si = InkWell(
        onTap: () => callback!(),
        child: Icon(icon!, color: ColorsTheme.grey40));

    return InputDecoration(
      border: uib(false),
      focusedBorder: uib(true),
      suffixIcon: isNeedSuffixIcon! ? si : null,
      hintText: hint,
      helperText: helperText != "" ? helperText : null,
      helperStyle: FontThemes.fontSize11w500W(color: ColorsTheme.primaryYellow),
      hintStyle: isFormContent!
          ? FontThemes.fontSize12w500W(color: ColorsTheme.grey40)
          : FontThemes.fontSize14wTx1(isHint: true),
    );
  }

  static BoxDecoration? boxDecoCatId(Color? backgroundColor) => BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
      );

  static BoxDecoration? customRadiusChip(
          Color? backgroundColor, double? radius) =>
      BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius!.r),
      );

  static BoxDecoration? dualBoxDeco({required bool? isDisabled}) =>
      BoxDecoration(
        color: isDisabled! ? ColorsTheme.white : ColorsTheme.primaryYellow,
        borderRadius: BorderRadius.circular(16.r),
      );

  static BoxDecoration? dualGradientColor() => BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        tileMode: TileMode.mirror,
        colors: [ColorsTheme.transparent, ColorsTheme.white],
      ));

  static BoxDecoration? underlineBorder() => BoxDecoration(
          border: Border(
        bottom: BorderSide(color: ColorsTheme.grey60, width: 1.0.w),
      ));

  static BoxDecoration? customBoxDecoRadius(double radius, Color colors) =>
      BoxDecoration(
        color: colors,
        borderRadius: BorderRadius.circular(radius.r),
      );

  //PADDING//
  static EdgeInsets symmetricPadding(double width, double height) =>
      EdgeInsets.symmetric(horizontal: width.w, vertical: height.h);

  static EdgeInsets spesificPadding(
          double left, double top, double right, double bottom) =>
      EdgeInsets.fromLTRB(left.w, top.h, right.w, bottom.h);

  static EdgeInsets allPadding(double all) => EdgeInsets.all(all);

  //STATUS & NAVIGATION COLOR//
  static navigationColor(Color? statusColors, Color? navColors) {
    var style = SystemUiOverlayStyle.light.copyWith(
        statusBarColor: statusColors,
        systemNavigationBarColor: navColors,
        statusBarIconBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  //GRID LAYOUT & ICON MENU//

  static SliverGridDelegate? gridDelegate =
      SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5.w,
          mainAxisSpacing: 5.h,
          childAspectRatio: 0.90);

  //LANGUAGE//

  static Future<Map<String, dynamic>> loadTranslationJSON(String locale) async {
    String data = await rootBundle.loadString('assets/translate/$locale.json');
    return json.decode(data);
  }

  static String? localeInit(BuildContext context) {
    Locale? locale = Localizations.localeOf(context);
    return "${locale.languageCode}_${locale.countryCode}";
  }

  //CALENDAR//

  static Theme? layoutTheme(Widget child) => Theme(
      data: ThemeData.light().copyWith(
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: ColorsTheme.grey80),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: ColorsTheme.primaryYellow,
          onSurface: ColorsTheme.grey80,
          // ignore: deprecated_member_use
          background: ColorsTheme.white,
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 100.h, horizontal: 25.w),
        child: child,
      ));
}
