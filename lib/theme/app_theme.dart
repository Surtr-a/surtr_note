import 'package:flutter/material.dart';
import 'package:surtr_note/utils/color.dart';

ThemeData get appThemeData => ThemeData(
    primaryColor: Colors.white,
    accentColor: CustomColor.MPink,
    appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: Colors.black54),
        actionsIconTheme: IconThemeData(color: Colors.black54)),
    hintColor: Colors.black38,
    dividerColor: Colors.black26,
    inputDecorationTheme: InputDecorationTheme(border: InputBorder.none));
