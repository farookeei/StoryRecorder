import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const regular = FontWeight.w400;
const medium = FontWeight.w500;
const semiBold = FontWeight.w600;
const bold = FontWeight.w700;

class TextStyleTheme {
  static const TextStyle euclid =
      TextStyle(fontWeight: regular, fontFamily: 'EuclidCircularB');

  TextStyle get displayLarge => euclid.copyWith(fontSize: 57.sp);

  TextStyle get displayMedium => displayLarge.copyWith(
        fontSize: 45.sp,
        fontWeight: semiBold,
      );

  TextStyle get displaySmall => displayLarge.copyWith(
        fontSize: 36.sp,
        fontWeight: medium,
      );

  TextStyle get headlineLarge => displayLarge.copyWith(
        fontSize: 32.sp,
        fontWeight: semiBold,
      );

  TextStyle get headlineMedium => displayLarge.copyWith(
        fontSize: 28.sp,
      );

  TextStyle get headlineSmall => displayLarge.copyWith(
        fontSize: 24.sp,
        fontWeight: semiBold,
      );
  TextStyle get titleLarge => displayLarge.copyWith(
        fontSize: 22.sp,
        fontWeight: semiBold,
      );
  TextStyle get titleMedium => displayLarge.copyWith(
        fontSize: 16.sp,
        fontWeight: medium,
      );
  TextStyle get titleSmall => displayLarge.copyWith(
        fontSize: 14.sp,
        fontWeight: regular,
      );
  TextStyle get labelLarge => displayLarge.copyWith(
        fontSize: 14.sp,
        fontWeight: semiBold,
      );
  TextStyle get labelMedium => displayLarge.copyWith(
        fontSize: 12.sp,
        fontWeight: medium,
      );
  TextStyle get labelSmall => displayLarge.copyWith(
        fontSize: 11.sp,
        fontWeight: regular,
      );
  TextStyle get bodyLarge => displayLarge.copyWith(
        fontSize: 16.sp,
        fontWeight: regular,
      );
  TextStyle get bodyMedium => displayLarge.copyWith(
        fontSize: 14.sp,
        fontWeight: regular,
      );
  TextStyle get bodySmall => displayLarge.copyWith(
        fontSize: 12.sp,
        fontWeight: regular,
      );

  TextStyle get caption =>
      euclid.copyWith(fontSize: 28.sp, fontWeight: semiBold);

  TextStyle get customBold => euclid.copyWith(
        fontWeight: bold,
        fontSize: 14.sp,
      );
  TextStyle get customHeading1 =>
      euclid.copyWith(fontWeight: medium, fontSize: 16.sp);

  TextStyle get customHeading2 =>
      euclid.copyWith(fontWeight: medium, fontSize: 19.sp);

  TextStyle get customHeading3 =>
      euclid.copyWith(fontWeight: bold, fontSize: 24.sp);
}
