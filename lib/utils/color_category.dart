import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Color buttonColor = '#40744D'.toColor();
Color buttonColor = '#074324'.toColor();
Color bgColor = "#f9f9f9".toColor();
// Color bgColor = "#C0C0C0".toColor();
Color subTitleColor = "#808080".toColor();
Color borderColor = "#DFDFDF".toColor();
Color regularBlack = "#000000".toColor();
Color blueGray50 = "#ebecef".toColor();
Color regularWhite = "#FFFFFF".toColor();
Color lightGray = "#E6E6E6".toColor();
Color lightGreen = "#E6E6E6".toColor();
Color tabbarBackground = "#F6F6F6".toColor();
Color dividerColor = "#F1F1F1".toColor();
Color darkGray = "#696969".toColor();
Color gray = "#F1F1F1".toColor();
Color black40 = "#808080".toColor();
Color black20 = "#DCDCDC".toColor();
Color redColor = "#FF3E3E".toColor();
Color lightColor = "#F4F4F4".toColor();

extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
