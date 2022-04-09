import 'package:flutter/cupertino.dart';

class DebugLog{
  DebugLog._();

  static void show(String? msg) {
    debugPrint('${DateTime.now()} DevDebug: $msg');
  }
}