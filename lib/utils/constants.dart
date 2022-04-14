import 'package:flutter/material.dart';

class Constants {
  Constants._();

  static final orderStatusColor = <String, Color>{
   'completed': const Color(0xFFE7FFE3),
  };

  static final orderStatus = <String, String>{
    'completed':'Đã hoàn thành',
  };

  static final orderTextStatusColor = <String, Color>{
    'completed': const Color(0xFF207513),
  };
}
