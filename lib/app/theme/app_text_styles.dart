import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get headingLarge => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textNavy,
  );

  static TextStyle get headingMedium => GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textNavy,
  );

  static TextStyle get headingSmall => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textNavy,
  );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
  );

  static TextStyle get bodySmall => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textGrey,
  );

  static TextStyle get label => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textGrey,
  );

  static TextStyle get button => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static TextStyle get balanceAmount => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static TextStyle get sectionTitle => GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textGrey,
    letterSpacing: 1.2,
  );
}
