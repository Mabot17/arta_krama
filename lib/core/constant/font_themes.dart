import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors_theme.dart';

class FontThemes {
  static fontSize10w500W({Color? color}) => GoogleFonts.openSans(
    fontSize: 10.sp,
    color: color,
    fontWeight: FontWeight.w500,
  );

  static fontSize10wBold({Color? color}) => GoogleFonts.openSans(
    fontSize: 10.sp,
    color: color,
    fontWeight: FontWeight.bold,
  );

  static fontSize11w500W({Color? color}) => GoogleFonts.openSans(
    fontSize: 11.sp,
    color: color,
    fontWeight: FontWeight.w500,
  );

  static fontSize12w400W({Color? color}) => GoogleFonts.openSans(
    fontSize: 12.sp,
    color: color,
    fontWeight: FontWeight.w400,
  );

  static fontSize12w500W({Color? color}) => GoogleFonts.openSans(
    fontSize: 12.sp,
    color: color,
    fontWeight: FontWeight.w500,
  );

  static fontSize12w500WST({Color? color}) => GoogleFonts.openSans(
    fontSize: 12.sp,
    color: color,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.lineThrough,
  );

  static fontSize12w500WItalic({Color? color}) => GoogleFonts.openSans(
    fontSize: 12.sp,
    color: color,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
  );

  static fontSize12wBold({Color? color}) => GoogleFonts.openSans(
    fontSize: 12.sp,
    color: color,
    fontWeight: FontWeight.bold,
  );

  static fontSize13w500W({Color? color}) => GoogleFonts.openSans(
    fontSize: 13.sp,
    color: color,
    fontWeight: FontWeight.w500,
  );

  static fontSize13wBold({Color? color}) => GoogleFonts.openSans(
    fontSize: 13.sp,
    color: color,
    fontWeight: FontWeight.bold,
  );

  static fontSize14w500W({Color? color}) => GoogleFonts.openSans(
    fontSize: 14.sp,
    color: color,
    fontWeight: FontWeight.w500,
  );

  static fontSize14wTx1({bool? isHint}) => GoogleFonts.openSans(
    fontSize: 14.sp,
    color: isHint! ? ColorsTheme.grey40 : ColorsTheme.grey60,
    fontWeight: FontWeight.w500,
  );

  static fontSize14wBx1({bool? isDisabled}) => GoogleFonts.openSans(
    fontSize: 14.sp,
    color: isDisabled! ? ColorsTheme.grey40 : ColorsTheme.grey80,
    fontWeight: FontWeight.w500,
  );

  static fontSize14w700W({Color? color}) => GoogleFonts.openSans(
    fontSize: 14.sp,
    color: color,
    fontWeight: FontWeight.w700,
  );

  static fontSize14wBold({Color? color}) => GoogleFonts.openSans(
    fontSize: 14.sp,
    color: color,
    fontWeight: FontWeight.bold,
  );

  static fontSize15wBold({Color? color}) => GoogleFonts.openSans(
    fontSize: 15.sp,
    color: color,
    fontWeight: FontWeight.bold,
  );

  static fontSize16w500W({Color? color}) => GoogleFonts.openSans(
    fontSize: 16.sp,
    color: color,
    fontWeight: FontWeight.w500
  );

  static fontSize16w800W({Color? color}) => GoogleFonts.openSans(
    fontSize: 16.sp,
    color: color,
    fontWeight: FontWeight.w800
  );

  static fontSize16wBold({Color? color}) => GoogleFonts.openSans(
    fontSize: 16.sp,
    color: color,
    fontWeight: FontWeight.bold
  );

  static fontSize18w500W({Color? color}) => GoogleFonts.openSans(
    fontSize: 18.sp,
    color: color,
    fontWeight: FontWeight.w500
  );
  
  static fontSize18wBold({Color? color}) => GoogleFonts.openSans(
    fontSize: 18.sp,
    color: color,
    fontWeight: FontWeight.bold
  );

  static fontSize24w400W() => GoogleFonts.quicksand(
    fontSize: 24.sp,
    color: ColorsTheme.grey80,
    fontWeight: FontWeight.w400
  );

  static fontSize24w500W({Color? color}) => GoogleFonts.quicksand(
    fontSize: 24.sp,
    color: color,
    fontWeight: FontWeight.w400
  );

  static fontSize24wBold() => GoogleFonts.quicksand(
    fontSize: 24.sp,
    color: ColorsTheme.grey80,
    fontWeight: FontWeight.bold
  );
}
