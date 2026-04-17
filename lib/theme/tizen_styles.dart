import 'package:flutter/material.dart';

class TizenStyles {
  // Colors
  static const Color slate950 = Color(0xFF020617);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color teal400 = Color(0xFF2DD4BF);
  static const Color cyan400 = Color(0xFF22D3EE);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color blue800 = Color(0xFF1E40AF);
  static const Color blue900 = Color(0xFF1E3A8A);

  // Text Sizes
  static const double baseFontSize = 17.0; // Increased
  static const double smallFontSize = 14.0;
  static const double tinyFontSize = 12.0;
  static const double headerFontSize = 18.0; // Increased

  // Text Styles
  static const TextStyle bodyText = TextStyle(
    color: slate200,
    fontSize: baseFontSize,
    height: 1.6,
  );

  static const TextStyle sentText = TextStyle(
    color: Colors.white,
    fontSize: baseFontSize,
  );

  static const TextStyle dateText = TextStyle(
    fontSize: tinyFontSize,
    letterSpacing: 1.5,
    color: slate500,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle headerText = TextStyle(
    fontSize: headerFontSize,
    fontWeight: FontWeight.w800,
    letterSpacing: 2.0,
    color: Colors.white,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: teal400,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 16,
    color: slate300,
  );

  // Gradients
  static const RadialGradient backgroundGradient = RadialGradient(
    center: Alignment.topRight,
    radius: 1.5,
    colors: [
      slate900,
      Colors.black,
      Colors.black,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [TizenStyles.blue600, TizenStyles.cyan400],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF2DD4BF)],
  );
}
