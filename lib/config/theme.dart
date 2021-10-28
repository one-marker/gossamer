import 'package:flutter/material.dart';
import 'package:frontend/config/fonts.dart';

import 'colours.dart';

ThemeData buildThemeData() {
  final baseTheme = ThemeData(fontFamily: AvailableFonts.primaryFont);

  return baseTheme.copyWith(
    primaryColor: primaryColor,
    primaryColorDark: primaryDark,
    primaryColorLight: primaryLight,
    accentColor: secondaryColor,
  );}