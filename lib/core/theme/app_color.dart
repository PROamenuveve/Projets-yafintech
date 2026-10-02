// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Couleurs principales
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);

  // Couleurs secondaires
  static const Color secondary = Color(0xFF7C3AED);
  static const Color secondaryLight = Color(0xFF8B5CF6);
  static const Color secondaryDark = Color(0xFF6D28D9);

  // Couleurs de succès/erreur
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Couleurs de fond
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);

  // Couleurs de texte
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textLight = Color(0xFF94A3B8);

  // personalisé
  static const Color couleur1 = Color.fromARGB(255, 154, 1, 162);
  static const Color couleur11 = Color.fromARGB(255, 234, 67, 243);
  static const Color couleur2 = Color.fromARGB(255, 3, 171, 177);
  static const Color couleur21 = Color.fromARGB(255, 82, 245, 150);
  static const Color couleur3 = Color.fromARGB(255, 182, 195, 3);
  static const Color couleur31 = Color.fromARGB(255, 231, 242, 82);
  static const Color couleur4 = Color.fromARGB(255, 108, 99, 255);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
