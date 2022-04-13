import 'package:flutter/material.dart';
import 'package:mobile/base/base_bloc.dart';
import 'package:mobile/prefs_util.dart';

import '../login/login_page.dart';
import '../navigation/navigation_page.dart';

class SplashBloc extends BaseBloc{

  Future<void> checkLogin(BuildContext context) async {
    final isLogin =
        PrefsUtil.getBool('IS_LOGIN', defValue: false) ?? false;
    startScreen(
        isLogin ? NavigationPage.routeName : LoginPage.routeName, context);
  }

  void startScreen(String route, BuildContext context) {
    Navigator.pushReplacementNamed(context, route);
  }
}