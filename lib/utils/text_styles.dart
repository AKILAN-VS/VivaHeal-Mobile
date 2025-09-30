import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  static TextStyle monText({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
    Color color = const Color.fromARGB(255, 0, 0, 0),
  }) {
    return GoogleFonts.lexend(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
