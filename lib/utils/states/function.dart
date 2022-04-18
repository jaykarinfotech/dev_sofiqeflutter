import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  Color toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length != 6 && hexColor.length != 8) {
      return Colors.white;
    }
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return Colors.white;
  }

  String toProperCurrencyString() {
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
    return '${format.currencySymbol} $this';
  }
}

extension DoubleExtension on double {
  String toProperCurrencyString() {
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
    return '${format.currencySymbol} ${this.toStringAsFixed(2)}';
  }
}
