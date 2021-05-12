import 'package:flutter/material.dart';

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (getPlatform(context) == TargetPlatform.android || getPlatform(context) == TargetPlatform.fuchsia) {
      return GlowingOverscrollIndicator(
        child: child,
        showLeading: false,
        showTrailing: true,
        axisDirection: axisDirection,
        color: Theme.of(context).accentColor,
      );
    } else {
      return child;
    }
  }
}