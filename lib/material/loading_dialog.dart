import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final bool canPop;
  const LoadingDialog({Key? key, this.canPop = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 拦截返回动作
    return WillPopScope(
        child: Center(
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        ),
        onWillPop: () async => canPop);
  }
}
