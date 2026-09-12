import 'package:flutter/material.dart';
import 'package:yafintech/core/theme/app_color.dart';

class AppOutils {
  static BorderRadius radius = BorderRadius.circular(20);
  static SizedBox espace05 = SizedBox(height: 5);
  static SizedBox espace10 = SizedBox(height: 10);
  static SizedBox espace20 = SizedBox(height: 20);
  static SizedBox espace50 = SizedBox(height: 50);
  static InputDecoration inputDecoration({
    String? hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Widget? counterText,
    String? errorText,
  }) {
    return InputDecoration(
      //filled: true,
      //fillColor: Colors.grey.shade100,

      hintText: hintText,
      labelText: labelText,

      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,

      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(width: 2, color: AppColors.couleur1),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(width: 2, color: AppColors.couleur1),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(width: 3, color: AppColors.couleur1),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(width: 2, color: Colors.red),
      ),

      //contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
